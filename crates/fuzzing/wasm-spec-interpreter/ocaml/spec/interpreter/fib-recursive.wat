;; Test `call` operator

(module
  ;; Auxiliary definitions

  (func $fib (export "fib") (param i64) (result i64)
    (if (result i64) (i64.le_u (local.get 0) (i64.const 1))
      (then (i64.const 1))
      (else
        (i64.add
          (call $fib (i64.sub (local.get 0) (i64.const 2)))
          (call $fib (i64.sub (local.get 0) (i64.const 1)))
        )
      )
    )
  )

  (func $fiblanding
    (i64.const 35)
    (call $fib)
    (return)
  )

  (start $fiblanding)
)

;; (assert_return (invoke "fib" (i64.const 10)) (i64.const 0))
