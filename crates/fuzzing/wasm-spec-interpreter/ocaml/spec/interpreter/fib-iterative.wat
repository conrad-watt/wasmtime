;; Test `call` operator

(module
  ;; Auxiliary definitions

  (func $fib (export "fib") (local i64 i64 i64 i64)
    (i64.const 100000000)
    (local.set 0)
    (i64.const 1)
    (local.set 1)
    (i64.const 1)
    (local.set 2)
    (i64.const 1)
    (local.set 3)
    (loop
      (if (i64.le_u (local.get 0) (local.get 1))
        (then (return (local.get 3)))
        (else
          (i64.add (local.get 2) (local.get 3))
          (local.get 3)
          (local.set 2)
          (local.set 3)
          (i64.add (i64.const 1) (local.get 1))
          (local.set 1)
          (br 1)
        )
      )
    )
    (unreachable)
  )

  (start $fib)
)
