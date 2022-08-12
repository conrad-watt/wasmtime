;; Test `call` operator

(module
  ;; Auxiliary definitions
  (memory 2000)

  (func $walk (export "walk") (local i32 i32)
    (loop
      (if (i32.ge_u (local.get 0) (i32.const 10000000))
         (then (local.get 1) (return))
         (else (i32.load (local.get 0)) (local.get 1) (i32.or) (local.set 1) (i32.const 1) (local.get 0) (i32.add) (local.set 0) (br 1))
      )
    )
    (unreachable)
  )

  (start $walk)
)
