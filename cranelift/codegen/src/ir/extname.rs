//! External names.
//!
//! These are identifiers for declaring entities defined outside the current
//! function. The name of an external declaration doesn't have any meaning to
//! Cranelift, which compiles functions independently.

use crate::ir::{KnownSymbol, LibCall};
use core::cmp;
use core::fmt::{self, Write};
use core::str::FromStr;

use cranelift_entity::EntityRef as _;
#[cfg(feature = "enable-serde")]
use serde::{Deserialize, Serialize};

use super::entities::UserExternalNameRef;
use super::function::FunctionParameters;

pub(crate) const TESTCASE_NAME_LENGTH: usize = 16;

/// An explicit name for a user-defined function, be it defined in code or in CLIF text.
///
/// This is used both for naming a function (for debugging purposes) and for declaring external
/// functions. In the latter case, this becomes an `ExternalName`, which gets embedded in
/// relocations later, etc.
#[derive(Clone, Debug)]
#[cfg_attr(feature = "enable-serde", derive(Serialize, Deserialize))]
pub enum UserFuncName {
    /// A user-defined name, with semantics left to the user.
    User(UserExternalName),
    /// A name for a test case, mostly intended for Cranelift testing.
    Testcase(TestcaseName),
}

impl UserFuncName {
    /// Creates a new external name from a sequence of bytes. Caller is expected
    /// to guarantee bytes are only ascii alphanumeric or `_`.
    pub fn testcase<T: AsRef<[u8]>>(v: T) -> Self {
        Self::Testcase(TestcaseName::new(v))
    }

    /// Create a new external name from a user-defined external function reference.
    pub fn user(namespace: u32, index: u32) -> Self {
        Self::User(UserExternalName { namespace, index })
    }
}

impl Default for UserFuncName {
    fn default() -> Self {
        UserFuncName::User(UserExternalName::default())
    }
}

impl fmt::Display for UserFuncName {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            UserFuncName::User(user) => user.fmt(f),
            UserFuncName::Testcase(testcase) => testcase.fmt(f),
        }
    }
}

/// An external name in a user-defined symbol table.
///
/// Cranelift does not interpret these numbers in any way, so they can represent arbitrary values.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Default)]
#[cfg_attr(feature = "enable-serde", derive(Serialize, Deserialize))]
pub struct UserExternalName {
    /// Arbitrary.
    pub namespace: u32,
    /// Arbitrary.
    pub index: u32,
}

impl fmt::Display for UserExternalName {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "u{}:{}", self.namespace, self.index)
    }
}

/// A name for a test case.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
#[cfg_attr(feature = "enable-serde", derive(Serialize, Deserialize))]
pub struct TestcaseName {
    /// How many of the bytes in `ascii` are valid?
    length: u8,
    /// Ascii bytes of the name.
    ascii: [u8; TESTCASE_NAME_LENGTH],
}

impl fmt::Display for TestcaseName {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_char('%')?;
        for byte in self.ascii.iter().take(self.length as usize) {
            f.write_char(*byte as char)?;
        }
        Ok(())
    }
}

impl TestcaseName {
    pub(crate) fn new<T: AsRef<[u8]>>(v: T) -> Self {
        let vec = v.as_ref();
        let len = cmp::min(vec.len(), TESTCASE_NAME_LENGTH);
        let mut bytes = [0u8; TESTCASE_NAME_LENGTH];
        bytes[0..len].copy_from_slice(&vec[0..len]);

        Self {
            length: len as u8,
            ascii: bytes,
        }
    }
}

/// The name of an external is either a reference to a user-defined symbol
/// table, or a short sequence of ascii bytes so that test cases do not have
/// to keep track of a symbol table.
///
/// External names are primarily used as keys by code using Cranelift to map
/// from a `cranelift_codegen::ir::FuncRef` or similar to additional associated
/// data.
///
/// External names can also serve as a primitive testing and debugging tool.
/// In particular, many `.clif` test files use function names to identify
/// functions.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
#[cfg_attr(feature = "enable-serde", derive(Serialize, Deserialize))]
pub enum ExternalName {
    /// A reference to a name in a user-defined symbol table.
    User(UserExternalNameRef),
    /// A test case function name of up to a hardcoded amount of ascii
    /// characters. This is not intended to be used outside test cases.
    TestCase(TestcaseName),
    /// A well-known runtime library function.
    LibCall(LibCall),
    /// A well-known symbol.
    KnownSymbol(KnownSymbol),
}

impl Default for ExternalName {
    fn default() -> Self {
        Self::User(UserExternalNameRef::new(0))
    }
}

impl ExternalName {
    /// Creates a new external name from a sequence of bytes. Caller is expected
    /// to guarantee bytes are only ascii alphanumeric or `_`.
    ///
    /// # Examples
    ///
    /// ```rust
    /// # use cranelift_codegen::ir::ExternalName;
    /// // Create `ExternalName` from a string.
    /// let name = ExternalName::testcase("hello");
    /// assert_eq!(name.display(None).to_string(), "%hello");
    /// ```
    pub fn testcase<T: AsRef<[u8]>>(v: T) -> Self {
        Self::TestCase(TestcaseName::new(v))
    }

    /// Create a new external name from a user-defined external function reference.
    ///
    /// # Examples
    /// ```rust
    /// # use cranelift_codegen::ir::{ExternalName, UserExternalNameRef};
    /// let user_func_ref: UserExternalNameRef = Default::default(); // usually obtained with `Function::declare_imported_user_function()`
    /// let name = ExternalName::user(user_func_ref);
    /// assert_eq!(name.display(None).to_string(), "userextname0");
    /// ```
    pub fn user(func_ref: UserExternalNameRef) -> Self {
        Self::User(func_ref)
    }

    /// Returns a display for the current `ExternalName`, with extra context to prettify the
    /// output.
    pub fn display<'a>(
        &'a self,
        params: Option<&'a FunctionParameters>,
    ) -> DisplayableExternalName<'a> {
        DisplayableExternalName { name: self, params }
    }
}

/// An `ExternalName` that has enough context to be displayed.
pub struct DisplayableExternalName<'a> {
    name: &'a ExternalName,
    params: Option<&'a FunctionParameters>,
}

impl<'a> fmt::Display for DisplayableExternalName<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match &self.name {
            ExternalName::User(func_ref) => {
                if let Some(params) = self.params {
                    let name = &params.user_named_funcs()[*func_ref];
                    write!(f, "u{}:{}", name.namespace, name.index)
                } else {
                    // Best effort.
                    write!(f, "{}", *func_ref)
                }
            }
            ExternalName::TestCase(testcase) => testcase.fmt(f),
            ExternalName::LibCall(lc) => write!(f, "%{}", lc),
            ExternalName::KnownSymbol(ks) => write!(f, "%{}", ks),
        }
    }
}

impl FromStr for ExternalName {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // Try to parse as a known symbol
        if let Ok(ks) = s.parse() {
            return Ok(Self::KnownSymbol(ks));
        }

        // Try to parse as a libcall name
        if let Ok(lc) = s.parse() {
            return Ok(Self::LibCall(lc));
        }

        // Otherwise its a test case name
        Ok(Self::testcase(s.as_bytes()))
    }
}

#[cfg(test)]
mod tests {
    use super::ExternalName;
    use crate::ir::{
        entities::UserExternalNameRef, function::FunctionParameters, LibCall, UserExternalName,
    };
    use alloc::string::ToString;
    use core::u32;
    use cranelift_entity::EntityRef as _;

    #[test]
    fn display_testcase() {
        assert_eq!(ExternalName::testcase("").display(None).to_string(), "%");
        assert_eq!(ExternalName::testcase("x").display(None).to_string(), "%x");
        assert_eq!(
            ExternalName::testcase("x_1").display(None).to_string(),
            "%x_1"
        );
        assert_eq!(
            ExternalName::testcase("longname12345678")
                .display(None)
                .to_string(),
            "%longname12345678"
        );
        // Constructor will silently drop bytes beyond the 16th
        assert_eq!(
            ExternalName::testcase("longname123456789")
                .display(None)
                .to_string(),
            "%longname12345678"
        );
    }

    #[test]
    fn display_user() {
        assert_eq!(
            ExternalName::user(UserExternalNameRef::new(0))
                .display(None)
                .to_string(),
            "userextname0"
        );
        assert_eq!(
            ExternalName::user(UserExternalNameRef::new(1))
                .display(None)
                .to_string(),
            "userextname1"
        );
        assert_eq!(
            ExternalName::user(UserExternalNameRef::new((u32::MAX - 1) as _))
                .display(None)
                .to_string(),
            "userextname4294967294"
        );

        let mut func_params = FunctionParameters::new();

        // ref 0
        func_params.ensure_user_func_name(UserExternalName {
            namespace: 13,
            index: 37,
        });

        // ref 1
        func_params.ensure_user_func_name(UserExternalName {
            namespace: 2,
            index: 4,
        });

        assert_eq!(
            ExternalName::user(UserExternalNameRef::new(0))
                .display(Some(&func_params))
                .to_string(),
            "u13:37"
        );

        assert_eq!(
            ExternalName::user(UserExternalNameRef::new(1))
                .display(Some(&func_params))
                .to_string(),
            "u2:4"
        );
    }

    #[test]
    fn parsing() {
        assert_eq!(
            "FloorF32".parse(),
            Ok(ExternalName::LibCall(LibCall::FloorF32))
        );
        assert_eq!(
            ExternalName::LibCall(LibCall::FloorF32)
                .display(None)
                .to_string(),
            "%FloorF32"
        );
    }
}
