(module
  (type $t0 (func (param i32 i32) (result i32)))
  (type $t1 (func))
  (type $t2 (func (param i32 i32)))
  (type $t3 (func (param i32 i32 i32)))
  (type $t4 (func (param i32 i32 i32 i32)))
  (type $t5 (func (param i32 i32 i32) (result i32)))
  (type $t6 (func (param i32 i32 i32 i32 i32) (result i32)))
  (type $t7 (func (param i32 i32 i32 i32 i32 i32) (result i32)))
  (type $t8 (func (result i64)))
  (type $t9 (func (result f32)))
  (import "spectest" "clock_ms" (func $env.clock_ms (type $t8)))
  (func $f1 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32)
    (if $I0
      (i32.and
        (local.tee $l3
          (i32.load16_u
            (local.get $p0)))
        (i32.const 128))
      (then
        (return
          (i32.and
            (local.get $l3)
            (i32.const 127)))))
    (local.set $l4
      (i32.or
        (i32.shl
          (local.tee $l2
            (i32.and
              (i32.shr_u
                (local.get $l3)
                (i32.const 3))
              (i32.const 15)))
          (i32.const 4))
        (local.get $l2)))
    (block $B1
      (block $B2
        (block $B3
          (br_table $B3 $B2 $B1
            (i32.and
              (local.tee $l2
                (local.get $l3))
              (i32.const 7))))
        (local.set $l2
          (call $f7
            (i32.load offset=24
              (local.get $p1))
            (i32.load
              (i32.add
                (local.get $p1)
                (i32.const 20)))
            (i32.load16_s
              (local.get $p1))
            (i32.load16_s offset=2
              (local.get $p1))
            (select
              (local.get $l4)
              (i32.const 34)
              (i32.gt_u
                (local.get $l4)
                (i32.const 34)))
            (i32.load16_u offset=56
              (local.get $p1))))
        (br_if $B1
          (i32.load16_u offset=62
            (local.get $p1)))
        (i32.store16 offset=62
          (local.get $p1)
          (local.get $l2))
        (br $B1))
      (local.set $l2
        (i32.load16_u offset=56
          (local.get $p1)))
      (local.set $l2
        (call $f12
          (call $f5
            (i32.load
              (local.tee $l5
                (i32.add
                  (local.get $p1)
                  (i32.const 40))))
            (i32.load offset=12
              (local.get $l5))
            (i32.load offset=4
              (local.get $l5))
            (i32.load offset=8
              (local.get $l5))
            (local.get $l4))
          (local.get $l2)))
      (br_if $B1
        (i32.load16_u offset=60
          (local.get $p1)))
      (i32.store16 offset=60
        (local.get $p1)
        (local.get $l2)))
    (i32.store16 offset=56
      (local.get $p1)
      (call $f10
        (local.get $l2)
        (i32.load16_u offset=56
          (local.get $p1))))
    (i32.store16
      (local.get $p0)
      (i32.or
        (i32.or
          (local.tee $p0
            (i32.and
              (local.get $l2)
              (i32.const 127)))
          (i32.and
            (local.get $l3)
            (i32.const 65280)))
        (i32.const 128)))
    (local.get $p0))
  (func $f2 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32)
    (local.set $l4
      (i32.load offset=36
        (local.get $p0)))
    (local.set $l16
      (block $B0 (result i32)
        (if $I1
          (i32.lt_s
            (local.tee $l11
              (i32.load16_s offset=4
                (local.get $p0)))
            (i32.const 1))
          (then
            (local.set $l9
              (local.get $p1))
            (br $B0
              (i32.const 0))))
        (local.set $l9
          (local.get $p1))
        (loop $L2
          (local.set $l3
            (local.get $l4))
          (block $B3
            (block $B4
              (if $I5
                (i32.gt_s
                  (i32.shr_s
                    (i32.shl
                      (local.get $l9)
                      (i32.const 16))
                    (i32.const 16))
                  (i32.const -1))
                (then
                  (loop $L6
                    (br_if $B3
                      (i32.eq
                        (i32.load16_u offset=2
                          (i32.load offset=4
                            (local.get $l3)))
                        (i32.and
                          (local.get $l9)
                          (i32.const 65535))))
                    (br_if $L6
                      (local.tee $l3
                        (i32.load
                          (local.get $l3)))))
                  (br $B4)))
              (loop $L7
                (br_if $B3
                  (i32.eqz
                    (i32.xor
                      (i32.load8_u
                        (i32.load offset=4
                          (local.get $l3)))
                      (i32.and
                        (local.get $l6)
                        (i32.const 255)))))
                (br_if $L7
                  (local.tee $l3
                    (i32.load
                      (local.get $l3))))))
            (local.set $l3
              (i32.const 0)))
          (block $B8
            (if $I9
              (i32.eqz
                (local.get $l4))
              (then
                (local.set $l4
                  (i32.const 0))
                (br $B8)))
            (local.set $l5
              (i32.const 0))
            (local.set $l2
              (local.get $l4))
            (loop $L10
              (local.set $l2
                (i32.load
                  (local.tee $l4
                    (local.get $l2))))
              (i32.store
                (local.get $l4)
                (local.get $l5))
              (local.set $l5
                (local.get $l4))
              (br_if $L10
                (local.get $l2))))
          (block $B11
            (if $I12
              (i32.eqz
                (local.get $l3))
              (then
                (local.set $l14
                  (i32.add
                    (local.get $l14)
                    (i32.const 1)))
                (local.set $l13
                  (i32.add
                    (i32.and
                      (i32.load8_u offset=1
                        (i32.load offset=4
                          (i32.load
                            (local.get $l4))))
                      (i32.const 1))
                    (local.get $l13)))
                (br $B11)))
            (local.set $l15
              (i32.add
                (local.get $l15)
                (i32.const 1)))
            (local.set $l13
              (i32.add
                (i32.and
                  (i32.and
                    (i32.shr_u
                      (local.tee $l2
                        (i32.load16_u
                          (i32.load offset=4
                            (local.get $l3))))
                      (i32.const 9))
                    (local.get $l2))
                  (i32.const 1))
                (local.get $l13)))
            (br_if $B11
              (i32.eqz
                (local.tee $l2
                  (i32.load
                    (local.get $l3)))))
            (i32.store
              (local.get $l3)
              (i32.load
                (local.get $l2)))
            (i32.store
              (local.get $l2)
              (i32.load
                (local.get $l4)))
            (i32.store
              (local.get $l4)
              (local.get $l2)))
          (local.set $l9
            (i32.add
              (i32.shr_u
                (i32.and
                  (i32.xor
                    (local.get $l9)
                    (i32.const -1))
                  (i32.const 32768))
                (i32.const 15))
              (local.get $l9)))
          (br_if $L2
            (i32.lt_s
              (local.tee $l6
                (i32.shr_s
                  (i32.add
                    (i32.shl
                      (local.get $l6)
                      (i32.const 16))
                    (i32.const 65536))
                  (i32.const 16)))
              (local.get $l11))))
        (i32.and
          (i32.add
            (local.get $l11)
            (i32.const -1))
          (i32.const 255))))
    (block $B13
      (block $B14
        (br_if $B14
          (i32.lt_s
            (local.get $p1)
            (i32.const 1)))
        (local.set $l10
          (i32.const 1))
        (loop $L15
          (br_if $B13
            (i32.lt_s
              (local.get $l10)
              (i32.const 1)))
          (local.set $l12
            (i32.const 0))
          (local.set $l6
            (i32.const 0))
          (local.set $l2
            (local.get $l4))
          (local.set $l4
            (i32.const 0))
          (loop $L16
            (local.set $l12
              (i32.add
                (local.tee $l17
                  (local.get $l12))
                (i32.const 1)))
            (local.set $l3
              (i32.const 0))
            (local.set $l5
              (local.get $l2))
            (local.set $l8
              (block $B17 (result i32)
                (block $B18
                  (loop $L19
                    (br_if $B18
                      (i32.eqz
                        (local.tee $l5
                          (i32.load
                            (local.get $l5)))))
                    (br_if $L19
                      (i32.ne
                        (local.get $l10)
                        (local.tee $l3
                          (i32.add
                            (local.get $l3)
                            (i32.const 1))))))
                  (br $B17
                    (local.get $l10)))
                (i32.add
                  (local.get $l3)
                  (i32.const 1))))
            (local.set $l3
              (local.get $l2))
            (local.set $l2
              (local.get $l5))
            (local.set $l7
              (local.get $l10))
            (loop $L20
              (block $B21
                (block $B22
                  (local.set $l5
                    (block $B23 (result i32)
                      (block $B24
                        (local.set $p1
                          (block $B25 (result i32)
                            (block $B26
                              (br_if $B26
                                (i32.gt_s
                                  (local.get $l8)
                                  (i32.const 0)))
                              (br_if $B22
                                (i32.eqz
                                  (local.get $l2)))
                              (br_if $B22
                                (i32.lt_s
                                  (local.get $l7)
                                  (i32.const 1)))
                              (br_if $B26
                                (local.get $l8))
                              (local.set $l7
                                (i32.add
                                  (local.get $l7)
                                  (i32.const -1)))
                              (local.set $l8
                                (i32.const 0))
                              (br $B25
                                (i32.load
                                  (local.get $l2))))
                            (br_if $B24
                              (i32.eqz
                                (local.get $l2)))
                            (br_if $B24
                              (i32.eqz
                                (local.get $l7)))
                            (local.set $p1
                              (i32.load offset=4
                                (local.get $l2)))
                            (br_if $B24
                              (i32.le_u
                                (i32.and
                                  (call $f1
                                    (i32.load offset=4
                                      (local.get $l3))
                                    (local.get $p0))
                                  (i32.const 65535))
                                (i32.and
                                  (call $f1
                                    (local.get $p1)
                                    (local.get $p0))
                                  (i32.const 65535))))
                            (local.set $l7
                              (i32.add
                                (local.get $l7)
                                (i32.const -1)))
                            (i32.load
                              (local.get $l2))))
                        (local.set $l11
                          (local.get $l3))
                        (br $B23
                          (local.get $l2)))
                      (local.set $l8
                        (i32.add
                          (local.get $l8)
                          (i32.const -1)))
                      (local.set $l11
                        (i32.load
                          (local.get $l3)))
                      (local.set $p1
                        (local.get $l2))
                      (local.get $l3)))
                  (if $I27
                    (i32.eqz
                      (local.get $l6))
                    (then
                      (local.set $l4
                        (local.get $l5))
                      (br $B21)))
                  (i32.store
                    (local.get $l6)
                    (local.get $l5))
                  (br $B21))
                (br_if $L16
                  (local.get $l2))
                (i32.store
                  (local.get $l6)
                  (i32.const 0))
                (local.set $l10
                  (i32.shl
                    (local.get $l10)
                    (i32.const 1)))
                (br_if $L15
                  (local.get $l17))
                (br $B14))
              (local.set $l3
                (local.get $l11))
              (local.set $l2
                (local.get $p1))
              (local.set $l6
                (local.get $l5))
              (br $L20))
            (unreachable))
          (unreachable))
        (unreachable))
      (local.set $l12
        (i32.add
          (i32.sub
            (i32.shl
              (local.get $l15)
              (i32.const 2))
            (local.get $l14))
          (local.get $l13)))
      (local.set $l6
        (i32.load offset=4
          (local.tee $p1
            (i32.load
              (local.get $l4)))))
      (i32.store offset=4
        (local.get $p1)
        (i32.load offset=4
          (local.tee $p0
            (i32.load
              (local.get $p1)))))
      (i32.store
        (local.get $p1)
        (i32.load
          (local.get $p0)))
      (i32.store offset=4
        (local.get $p0)
        (local.get $l6))
      (i32.store
        (local.get $p0)
        (i32.const 0))
      (block $B28
        (block $B29
          (block $B30
            (if $I31
              (i32.le_s
                (i32.shr_s
                  (i32.shl
                    (local.get $l9)
                    (i32.const 16))
                  (i32.const 16))
                (i32.const -1))
              (then
                (br_if $B30
                  (i32.eqz
                    (local.get $l4)))
                (local.set $l2
                  (local.get $l4))
                (loop $L32
                  (br_if $B29
                    (i32.eq
                      (local.get $l16)
                      (i32.load8_u
                        (i32.load offset=4
                          (local.get $l2)))))
                  (br_if $L32
                    (local.tee $l2
                      (i32.load
                        (local.get $l2)))))
                (br $B30)))
            (br_if $B30
              (i32.eqz
                (local.get $l4)))
            (local.set $p1
              (i32.and
                (local.get $l9)
                (i32.const 65535)))
            (local.set $l2
              (local.get $l4))
            (loop $L33
              (br_if $B29
                (i32.eq
                  (i32.load16_u offset=2
                    (i32.load offset=4
                      (local.get $l2)))
                  (local.get $p1)))
              (br_if $L33
                (local.tee $l2
                  (i32.load
                    (local.get $l2))))))
          (br_if $B28
            (i32.eqz
              (local.tee $l2
                (i32.load
                  (local.get $l4))))))
        (loop $L34
          (local.set $l12
            (call $f12
              (i32.load16_s
                (i32.load offset=4
                  (local.get $l4)))
              (i32.and
                (local.get $l12)
                (i32.const 65535))))
          (br_if $L34
            (local.tee $l2
              (i32.load
                (local.get $l2)))))
        (local.set $l6
          (i32.load offset=4
            (local.get $p0))))
      (i32.store offset=4
        (local.get $p0)
        (i32.load offset=4
          (local.tee $p1
            (i32.load
              (local.get $l4)))))
      (i32.store
        (local.get $p0)
        (i32.load
          (local.get $p1)))
      (i32.store offset=4
        (local.get $p1)
        (local.get $l6))
      (i32.store
        (local.get $p1)
        (local.get $p0))
      (local.set $p0
        (i32.const 1))
      (loop $L35
        (if $I36
          (i32.ge_s
            (local.get $p0)
            (i32.const 1))
          (then
            (local.set $l10
              (i32.const 0))
            (local.set $l6
              (i32.const 0))
            (local.set $l2
              (local.get $l4))
            (local.set $l4
              (i32.const 0))
            (loop $L37
              (local.set $l10
                (i32.add
                  (local.tee $l9
                    (local.get $l10))
                  (i32.const 1)))
              (local.set $l3
                (i32.const 0))
              (local.set $l5
                (local.get $l2))
              (local.set $l8
                (block $B38 (result i32)
                  (block $B39
                    (loop $L40
                      (br_if $B39
                        (i32.eqz
                          (local.tee $l5
                            (i32.load
                              (local.get $l5)))))
                      (br_if $L40
                        (i32.ne
                          (local.get $p0)
                          (local.tee $l3
                            (i32.add
                              (local.get $l3)
                              (i32.const 1))))))
                    (br $B38
                      (local.get $p0)))
                  (i32.add
                    (local.get $l3)
                    (i32.const 1))))
              (local.set $l3
                (local.get $l2))
              (local.set $l2
                (local.get $l5))
              (local.set $l7
                (local.get $p0))
              (loop $L41
                (block $B42
                  (block $B43
                    (local.set $p1
                      (block $B44 (result i32)
                        (block $B45
                          (local.set $l11
                            (block $B46 (result i32)
                              (block $B47
                                (br_if $B47
                                  (i32.gt_s
                                    (local.get $l8)
                                    (i32.const 0)))
                                (br_if $B43
                                  (i32.eqz
                                    (local.get $l2)))
                                (br_if $B43
                                  (i32.lt_s
                                    (local.get $l7)
                                    (i32.const 1)))
                                (br_if $B47
                                  (local.get $l8))
                                (local.set $l7
                                  (i32.add
                                    (local.get $l7)
                                    (i32.const -1)))
                                (local.set $l8
                                  (i32.const 0))
                                (br $B46
                                  (i32.load
                                    (local.get $l2))))
                              (br_if $B45
                                (i32.eqz
                                  (local.get $l2)))
                              (br_if $B45
                                (i32.eqz
                                  (local.get $l7)))
                              (i32.store8
                                (local.tee $p1
                                  (i32.load offset=4
                                    (local.get $l3)))
                                (i32.load8_u offset=1
                                  (local.get $p1)))
                              (i32.store8
                                (local.tee $l5
                                  (i32.load offset=4
                                    (local.get $l2)))
                                (i32.load8_u offset=1
                                  (local.get $l5)))
                              (br_if $B45
                                (i32.le_s
                                  (i32.load16_s offset=2
                                    (local.get $p1))
                                  (i32.load16_s offset=2
                                    (local.get $l5))))
                              (local.set $l7
                                (i32.add
                                  (local.get $l7)
                                  (i32.const -1)))
                              (i32.load
                                (local.get $l2))))
                          (local.set $l5
                            (local.get $l2))
                          (br $B44
                            (local.get $l3)))
                        (local.set $l8
                          (i32.add
                            (local.get $l8)
                            (i32.const -1)))
                        (local.set $l11
                          (local.get $l2))
                        (local.set $l5
                          (local.get $l3))
                        (i32.load
                          (local.get $l3))))
                    (if $I48
                      (i32.eqz
                        (local.get $l6))
                      (then
                        (local.set $l4
                          (local.get $l5))
                        (br $B42)))
                    (i32.store
                      (local.get $l6)
                      (local.get $l5))
                    (br $B42))
                  (br_if $L37
                    (local.get $l2))
                  (i32.store
                    (local.get $l6)
                    (i32.const 0))
                  (local.set $p0
                    (i32.shl
                      (local.get $p0)
                      (i32.const 1)))
                  (br_if $L35
                    (local.get $l9))
                  (if $I49
                    (local.tee $l2
                      (i32.load
                        (local.get $l4)))
                    (then
                      (loop $L50
                        (local.set $l12
                          (call $f12
                            (i32.load16_s
                              (i32.load offset=4
                                (local.get $l4)))
                            (i32.and
                              (local.get $l12)
                              (i32.const 65535))))
                        (br_if $L50
                          (local.tee $l2
                            (i32.load
                              (local.get $l2)))))))
                  (return
                    (i32.and
                      (local.get $l12)
                      (i32.const 65535))))
                (local.set $l3
                  (local.get $p1))
                (local.set $l2
                  (local.get $l11))
                (local.set $l6
                  (local.get $l5))
                (br $L41))
              (unreachable))
            (unreachable))))
      (loop $L51
        (br $L51))
      (unreachable))
    (loop $L52
      (br $L52))
    (unreachable))
  (func $f3 (type $t5) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32)
    (i32.store
      (local.get $p1)
      (i32.const 0))
    (i32.store offset=4
      (local.get $p1)
      (local.tee $l7
        (i32.add
          (local.get $p1)
          (i32.shl
            (local.tee $l6
              (i32.add
                (i32.div_u
                  (local.get $p0)
                  (i32.const 20))
                (i32.const -2)))
            (i32.const 3)))))
    (i32.store align=2
      (local.get $l7)
      (i32.const 32896))
    (local.set $l9
      (i32.add
        (local.get $l7)
        (i32.shl
          (local.get $l6)
          (i32.const 2))))
    (local.set $l3
      (i32.add
        (local.get $p1)
        (i32.const 8)))
    (local.set $l5
      (i32.add
        (local.get $l7)
        (i32.const 4)))
    (block $B0
      (br_if $B0
        (i32.lt_u
          (local.get $p0)
          (i32.const 100)))
      (if $I1
        (i32.le_u
          (local.get $l9)
          (local.tee $p0
            (i32.add
              (local.get $l5)
              (i32.const 4))))
        (then
          (br $B0)))
      (i32.store
        (local.get $p1)
        (local.get $l3))
      (i32.store offset=8
        (local.get $p1)
        (i32.const 0))
      (i32.store align=2
        (local.get $l5)
        (i32.const 2147483647))
      (i32.store
        (i32.add
          (local.get $p1)
          (i32.const 12))
        (local.get $l5))
      (local.set $l4
        (local.get $l3))
      (local.set $l5
        (local.get $p0))
      (local.set $l3
        (i32.add
          (local.get $p1)
          (i32.const 16))))
    (if $I2
      (local.get $l6)
      (then
        (local.set $p0
          (i32.const 0))
        (loop $L3
          (block $B4
            (br_if $B4
              (i32.ge_u
                (local.tee $l8
                  (i32.add
                    (local.get $l3)
                    (i32.const 8)))
                (local.get $l7)))
            (br_if $B4
              (i32.ge_u
                (local.tee $l10
                  (i32.add
                    (local.get $l5)
                    (i32.const 4)))
                (local.get $l9)))
            (i32.store
              (local.get $l3)
              (local.get $l4))
            (i32.store offset=4
              (local.get $l3)
              (local.get $l5))
            (i32.store16 offset=2
              (local.get $l5)
              (i32.const 32767))
            (i32.store16
              (local.get $l5)
              (i32.or
                (i32.shl
                  (local.tee $l4
                    (i32.or
                      (i32.and
                        (i32.shl
                          (i32.xor
                            (local.get $p0)
                            (local.get $p2))
                          (i32.const 3))
                        (i32.const 120))
                      (i32.and
                        (local.get $p0)
                        (i32.const 7))))
                  (i32.const 8))
                (local.get $l4)))
            (i32.store
              (local.get $p1)
              (local.get $l3))
            (local.set $l4
              (local.get $l3))
            (local.set $l5
              (local.get $l10))
            (local.set $l3
              (local.get $l8)))
          (br_if $L3
            (i32.ne
              (local.get $l6)
              (local.tee $p0
                (i32.add
                  (local.get $p0)
                  (i32.const 1))))))))
    (if $I5
      (local.tee $l3
        (i32.load
          (local.get $l4)))
      (then
        (local.set $l8
          (i32.div_u
            (local.get $l6)
            (i32.const 5)))
        (local.set $p0
          (i32.const 1))
        (loop $L6
          (local.set $l5
            (i32.add
              (local.get $p0)
              (i32.const 1)))
          (i32.store16 offset=2
            (i32.load offset=4
              (local.get $l4))
            (if $I7 (result i32)
              (i32.ge_u
                (local.get $p0)
                (local.get $l8))
              (then
                (i32.or
                  (i32.and
                    (i32.shl
                      (local.get $l5)
                      (i32.const 8))
                    (i32.const 1792))
                  (i32.and
                    (i32.xor
                      (local.get $p0)
                      (local.get $p2))
                    (i32.const 16383))))
              (else
                (local.get $p0))))
          (local.set $p0
            (local.get $l5))
          (br_if $L6
            (local.tee $l3
              (i32.load
                (local.tee $l4
                  (local.get $l3))))))))
    (local.set $l6
      (i32.const 1))
    (loop $L8
      (if $I9
        (i32.ge_s
          (local.get $l6)
          (i32.const 1))
        (then
          (local.set $l9
            (i32.const 0))
          (local.set $l5
            (i32.const 0))
          (local.set $p0
            (local.get $p1))
          (local.set $p1
            (i32.const 0))
          (loop $L10
            (local.set $l9
              (i32.add
                (local.tee $l11
                  (local.get $l9))
                (i32.const 1)))
            (local.set $l3
              (i32.const 0))
            (local.set $l4
              (local.get $p0))
            (local.set $l7
              (block $B11 (result i32)
                (block $B12
                  (loop $L13
                    (br_if $B12
                      (i32.eqz
                        (local.tee $l4
                          (i32.load
                            (local.get $l4)))))
                    (br_if $L13
                      (i32.ne
                        (local.get $l6)
                        (local.tee $l3
                          (i32.add
                            (local.get $l3)
                            (i32.const 1))))))
                  (br $B11
                    (local.get $l6)))
                (i32.add
                  (local.get $l3)
                  (i32.const 1))))
            (local.set $l3
              (local.get $p0))
            (local.set $p0
              (local.get $l4))
            (local.set $p2
              (local.get $l6))
            (loop $L14
              (block $B15
                (block $B16
                  (local.set $l4
                    (block $B17 (result i32)
                      (block $B18
                        (local.set $p2
                          (block $B19 (result i32)
                            (block $B20
                              (br_if $B20
                                (i32.gt_s
                                  (local.get $l7)
                                  (i32.const 0)))
                              (br_if $B16
                                (i32.eqz
                                  (local.get $p0)))
                              (br_if $B16
                                (i32.lt_s
                                  (local.get $p2)
                                  (i32.const 1)))
                              (br_if $B20
                                (local.get $l7))
                              (local.set $l8
                                (i32.load
                                  (local.get $p0)))
                              (local.set $l7
                                (i32.const 0))
                              (br $B19
                                (i32.add
                                  (local.get $p2)
                                  (i32.const -1))))
                            (br_if $B18
                              (i32.eqz
                                (local.get $p0)))
                            (br_if $B18
                              (i32.eqz
                                (local.get $p2)))
                            (i32.store8
                              (local.tee $l4
                                (i32.load offset=4
                                  (local.get $l3)))
                              (i32.load8_u offset=1
                                (local.get $l4)))
                            (i32.store8
                              (local.tee $l8
                                (i32.load offset=4
                                  (local.get $p0)))
                              (i32.load8_u offset=1
                                (local.get $l8)))
                            (br_if $B18
                              (i32.le_s
                                (i32.load16_s offset=2
                                  (local.get $l4))
                                (i32.load16_s offset=2
                                  (local.get $l8))))
                            (local.set $l8
                              (i32.load
                                (local.get $p0)))
                            (i32.add
                              (local.get $p2)
                              (i32.const -1))))
                        (local.set $l10
                          (local.get $l3))
                        (br $B17
                          (local.get $p0)))
                      (local.set $l7
                        (i32.add
                          (local.get $l7)
                          (i32.const -1)))
                      (local.set $l10
                        (i32.load
                          (local.get $l3)))
                      (local.set $l8
                        (local.get $p0))
                      (local.get $l3)))
                  (if $I21
                    (i32.eqz
                      (local.get $l5))
                    (then
                      (local.set $p1
                        (local.get $l4))
                      (br $B15)))
                  (i32.store
                    (local.get $l5)
                    (local.get $l4))
                  (br $B15))
                (br_if $L10
                  (local.get $p0))
                (i32.store
                  (local.get $l5)
                  (i32.const 0))
                (local.set $l6
                  (i32.shl
                    (local.get $l6)
                    (i32.const 1)))
                (br_if $L8
                  (local.get $l11))
                (return
                  (local.get $p1)))
              (local.set $l3
                (local.get $l10))
              (local.set $p0
                (local.get $l8))
              (local.set $l5
                (local.get $l4))
              (br $L14))
            (unreachable))
          (unreachable))))
    (loop $L22
      (br $L22))
    (unreachable))
  (func $run (export "run") (type $t9) (result f32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i64) (local $l15 f32) (local $l16 f64)
    (global.set $g0
      (local.tee $l0
        (i32.sub
          (global.get $g0)
          (i32.const 80))))
    (i32.store offset=76
      (local.get $l0)
      (i32.const 0))
    (i32.store8
      (local.tee $l13
        (i32.add
          (local.get $l0)
          (i32.const 66)))
      (i32.const 1))
    (i32.store16
      (local.get $l0)
      (i32.load
        (i32.load
          (i32.const 800))))
    (i32.store16 offset=2
      (local.get $l0)
      (i32.load
        (i32.load
          (i32.const 804))))
    (i32.store16 offset=4
      (local.get $l0)
      (i32.load
        (i32.load
          (i32.const 808))))
    (i32.store offset=28
      (local.get $l0)
      (i32.load
        (i32.load
          (i32.const 812))))
    (i32.store offset=32
      (local.get $l0)
      (local.tee $l1
        (select
          (local.tee $l1
            (i32.load
              (i32.load
                (i32.const 816))))
          (i32.const 7)
          (local.get $l1))))
    (block $B0
      (if $I1
        (i32.or
          (local.tee $l5
            (i32.load16_u offset=4
              (local.get $l0)))
          (i32.or
            (local.tee $l4
              (i32.load16_u offset=2
                (local.get $l0)))
            (local.tee $l2
              (i32.load16_u
                (local.get $l0)))))
        (then
          (br_if $B0
            (i32.ne
              (i32.and
                (local.get $l2)
                (i32.const 65535))
              (i32.const 1)))
          (local.set $l3
            (i32.const 13333))
          (br_if $B0
            (i32.or
              (local.get $l4)
              (local.get $l5)))))
      (i32.store16 offset=4
        (local.get $l0)
        (i32.const 102))
      (i32.store16 offset=2
        (local.get $l0)
        (local.get $l3))
      (i32.store16
        (local.get $l0)
        (local.get $l3))
      (local.set $l2
        (local.get $l3)))
    (i32.store16 offset=64
      (local.get $l0)
      (i32.const 0))
    (i32.store offset=8
      (local.get $l0)
      (i32.const 832))
    (i32.store offset=24
      (local.get $l0)
      (local.tee $l6
        (i32.div_u
          (i32.const 2000)
          (i32.add
            (i32.add
              (local.tee $l5
                (i32.and
                  (local.get $l1)
                  (i32.const 1)))
              (i32.shr_u
                (local.tee $l4
                  (i32.and
                    (local.get $l1)
                    (i32.const 2)))
                (i32.const 1)))
            (i32.shr_u
              (local.tee $l3
                (i32.and
                  (local.get $l1)
                  (i32.const 4)))
              (i32.const 2))))))
    (if $I2
      (local.get $l5)
      (then
        (i32.store offset=12
          (local.get $l0)
          (i32.const 832))
        (local.set $l7
          (i32.const 1))))
    (if $I3
      (local.get $l4)
      (then
        (i32.store
          (i32.add
            (local.get $l0)
            (i32.const 16))
          (i32.add
            (i32.mul
              (local.get $l6)
              (local.get $l7))
            (i32.const 832)))
        (local.set $l7
          (i32.add
            (local.get $l7)
            (i32.const 1)))))
    (if $I4
      (local.get $l3)
      (then
        (i32.store
          (i32.add
            (local.get $l0)
            (i32.const 20))
          (i32.add
            (i32.mul
              (local.get $l6)
              (local.get $l7))
            (i32.const 832)))))
    (if $I7
      (i32.and
        (if $I6 (result i32)
          (if $I5 (result i32)
            (local.get $l5)
            (then
              (i32.store offset=36
                (local.get $l0)
                (call $f3
                  (local.get $l6)
                  (i32.load offset=12
                    (local.get $l0))
                  (i32.shr_s
                    (i32.shl
                      (local.get $l2)
                      (i32.const 16))
                    (i32.const 16))))
              (i32.and
                (local.tee $l1
                  (i32.load offset=32
                    (local.get $l0)))
                (i32.const 2)))
            (else
              (local.get $l4)))
          (then
            (call $f6
              (i32.load offset=24
                (local.get $l0))
              (i32.load offset=16
                (local.get $l0))
              (i32.or
                (i32.load16_s
                  (local.get $l0))
                (i32.shl
                  (i32.load16_u offset=2
                    (local.get $l0))
                  (i32.const 16)))
              (i32.add
                (local.get $l0)
                (i32.const 40)))
            (i32.load offset=32
              (local.get $l0)))
          (else
            (local.get $l1)))
        (i32.const 4))
      (then
        (call $f9
          (i32.load offset=24
            (local.get $l0))
          (i32.load16_s
            (local.get $l0))
          (i32.load offset=20
            (local.get $l0)))))
    (if $I8
      (i32.eqz
        (i32.load offset=28
          (local.get $l0)))
      (then
        (i32.store offset=28
          (local.get $l0)
          (i32.const 1))
        (local.set $l1
          (i32.const 1))
        (loop $L9
          (i32.store offset=28
            (local.get $l0)
            (i32.mul
              (local.get $l1)
              (i32.const 10)))
          (call $f14)
          (i64.store offset=56
            (local.get $l0)
            (i64.const 0))
          (block $B10
            (br_if $B10
              (i32.eqz
                (local.tee $l1
                  (i32.load offset=28
                    (local.get $l0)))))
            (i32.store16 offset=56
              (local.get $l0)
              (call $f10
                (call $f2
                  (local.get $l0)
                  (i32.const 1))
                (i32.load16_u offset=56
                  (local.get $l0))))
            (i32.store16 offset=58
              (local.get $l0)
              (local.tee $l3
                (call $f10
                  (call $f2
                    (local.get $l0)
                    (i32.const -1))
                  (i32.load16_u offset=56
                    (local.get $l0)))))
            (i32.store16 offset=56
              (local.get $l0)
              (local.get $l3))
            (br_if $B10
              (i32.eq
                (local.get $l1)
                (i32.const 1)))
            (local.set $l1
              (i32.add
                (local.get $l1)
                (i32.const -1)))
            (loop $L11
              (i32.store16 offset=56
                (local.get $l0)
                (call $f10
                  (call $f2
                    (local.get $l0)
                    (i32.const 1))
                  (i32.load16_u offset=56
                    (local.get $l0))))
              (i32.store16 offset=56
                (local.get $l0)
                (call $f10
                  (call $f2
                    (local.get $l0)
                    (i32.const -1))
                  (i32.load16_u offset=56
                    (local.get $l0))))
              (br_if $L11
                (local.tee $l1
                  (i32.add
                    (local.get $l1)
                    (i32.const -1))))))
          (call $f15)
          (if $I12
            (i32.eqz
              (i32.xor
                (f64.lt
                  (local.tee $l16
                    (f64.div
                      (f64.convert_i64_u
                        (i64.sub
                          (i64.load
                            (i32.const 2856))
                          (i64.load
                            (i32.const 2848))))
                      (f64.const 0x1.f4p+9 (;=1000;))))
                  (f64.const 0x1p+0 (;=1;)))
                (i32.const 1)))
            (then
              (local.set $l1
                (i32.load offset=28
                  (local.get $l0)))
              (br $L9))))
        (i32.store offset=28
          (local.get $l0)
          (i32.mul
            (i32.load offset=28
              (local.get $l0))
            (i32.add
              (i32.div_u
                (i32.const 10)
                (select
                  (local.tee $l3
                    (block $B13 (result i32)
                      (if $I14
                        (i32.and
                          (f64.lt
                            (local.get $l16)
                            (f64.const 0x1p+32 (;=4.29497e+09;)))
                          (f64.ge
                            (local.get $l16)
                            (f64.const 0x0p+0 (;=0;))))
                        (then
                          (br $B13
                            (i32.trunc_f64_u
                              (local.get $l16)))))
                      (i32.const 0)))
                  (i32.const 1)
                  (local.get $l3)))
              (i32.const 1))))))
    (call $f14)
    (i64.store offset=56
      (local.get $l0)
      (i64.const 0))
    (block $B15
      (br_if $B15
        (i32.eqz
          (local.tee $l1
            (i32.load offset=28
              (local.get $l0)))))
      (i32.store16 offset=56
        (local.get $l0)
        (call $f10
          (call $f2
            (local.get $l0)
            (i32.const 1))
          (i32.load16_u offset=56
            (local.get $l0))))
      (i32.store16 offset=58
        (local.get $l0)
        (local.tee $l3
          (call $f10
            (call $f2
              (local.get $l0)
              (i32.const -1))
            (i32.load16_u offset=56
              (local.get $l0)))))
      (i32.store16 offset=56
        (local.get $l0)
        (local.get $l3))
      (br_if $B15
        (i32.eq
          (local.get $l1)
          (i32.const 1)))
      (local.set $l1
        (i32.add
          (local.get $l1)
          (i32.const -1)))
      (loop $L16
        (i32.store16 offset=56
          (local.get $l0)
          (call $f10
            (call $f2
              (local.get $l0)
              (i32.const 1))
            (i32.load16_u offset=56
              (local.get $l0))))
        (i32.store16 offset=56
          (local.get $l0)
          (call $f10
            (call $f2
              (local.get $l0)
              (i32.const -1))
            (i32.load16_u offset=56
              (local.get $l0))))
        (br_if $L16
          (local.tee $l1
            (i32.add
              (local.get $l1)
              (i32.const -1))))))
    (call $f15)
    (local.set $l2
      (i32.const 0))
    (local.set $l14
      (i64.sub
        (i64.load
          (i32.const 2856))
        (i64.load
          (i32.const 2848))))
    (local.set $l3
      (call $f12
        (i32.load16_s
          (local.get $l0))
        (i32.const 0)))
    (local.set $l3
      (call $f12
        (i32.load16_s offset=2
          (local.get $l0))
        (local.get $l3)))
    (local.set $l1
      (call $f12
        (i32.load16_s offset=4
          (local.get $l0))
        (local.get $l3)))
    (local.set $l3
      (i32.const 65535))
    (block $B17
      (block $B18
        (block $B19
          (if $I20
            (i32.le_s
              (local.tee $l1
                (call $f12
                  (i32.load16_s offset=24
                    (local.get $l0))
                  (local.get $l1)))
              (i32.const 31492))
            (then
              (br_if $B19
                (i32.eq
                  (local.get $l1)
                  (i32.const 6386)))
              (br_if $B17
                (i32.ne
                  (local.get $l1)
                  (i32.const 20143)))
              (local.set $l2
                (i32.const 2))
              (br $B18)))
          (if $I21
            (i32.ne
              (local.get $l1)
              (i32.const 59893))
            (then
              (br_if $B18
                (i32.eq
                  (local.get $l1)
                  (i32.const 35330)))
              (br_if $B17
                (i32.ne
                  (local.get $l1)
                  (i32.const 31493)))
              (local.set $l2
                (i32.const 1))
              (br $B18)))
          (local.set $l2
            (i32.const 3))
          (br $B18))
        (local.set $l2
          (i32.const 4)))
      (local.set $l3
        (i32.const 0))
      (br_if $B17
        (i32.eqz
          (local.tee $l8
            (i32.load
              (i32.const 824)))))
      (local.set $l9
        (i32.and
          (local.tee $l4
            (i32.load offset=32
              (local.get $l0)))
          (i32.const 4)))
      (local.set $l12
        (i32.and
          (local.get $l4)
          (i32.const 2)))
      (local.set $l10
        (i32.add
          (local.tee $l1
            (i32.shl
              (local.get $l2)
              (i32.const 1)))
          (i32.const 532)))
      (local.set $l7
        (i32.add
          (local.get $l1)
          (i32.const 522)))
      (local.set $l11
        (i32.load16_u offset=62
          (local.get $l0)))
      (local.set $l6
        (i32.load16_u offset=60
          (local.get $l0)))
      (block $B22
        (if $I23
          (i32.and
            (local.get $l4)
            (i32.const 1))
          (then
            (local.set $l5
              (select
                (i32.const 2)
                (i32.const 1)
                (local.tee $l4
                  (i32.ne
                    (i32.load16_u offset=58
                      (local.get $l0))
                    (i32.load16_u
                      (i32.add
                        (local.get $l1)
                        (i32.const 512)))))))
            (local.set $l2
              (i32.const 0))
            (loop $L24
              (local.set $l1
                (local.get $l4))
              (if $I25
                (local.get $l12)
                (then
                  (local.set $l1
                    (select
                      (local.get $l4)
                      (local.get $l5)
                      (i32.eq
                        (local.get $l6)
                        (i32.load16_u
                          (local.get $l7)))))))
              (if $I26
                (local.get $l9)
                (then
                  (local.set $l1
                    (i32.add
                      (local.get $l1)
                      (i32.ne
                        (local.get $l11)
                        (i32.load16_u
                          (local.get $l10)))))))
              (local.set $l3
                (i32.add
                  (local.get $l1)
                  (local.get $l3)))
              (br_if $L24
                (i32.gt_u
                  (local.get $l8)
                  (i32.and
                    (local.tee $l2
                      (i32.add
                        (local.get $l2)
                        (i32.const 1)))
                    (i32.const 65535)))))
            (br $B22)))
        (if $I27
          (i32.eqz
            (local.get $l12))
          (then
            (local.set $l2
              (i32.const 0))
            (loop $L28
              (local.set $l1
                (i32.const 0))
              (if $I29
                (local.get $l9)
                (then
                  (local.set $l1
                    (i32.ne
                      (local.get $l11)
                      (i32.load16_u
                        (local.get $l10))))))
              (local.set $l3
                (i32.add
                  (local.get $l1)
                  (local.get $l3)))
              (br_if $L28
                (i32.gt_u
                  (local.get $l8)
                  (i32.and
                    (local.tee $l2
                      (i32.add
                        (local.get $l2)
                        (i32.const 1)))
                    (i32.const 65535)))))
            (br $B22)))
        (local.set $l5
          (select
            (i32.const 2)
            (i32.const 1)
            (local.tee $l4
              (i32.ne
                (local.get $l6)
                (i32.load16_u
                  (local.get $l7))))))
        (local.set $l2
          (i32.const 0))
        (loop $L30
          (local.set $l1
            (local.get $l4))
          (if $I31
            (local.get $l9)
            (then
              (local.set $l1
                (select
                  (local.get $l4)
                  (local.get $l5)
                  (i32.eq
                    (local.get $l11)
                    (i32.load16_u
                      (local.get $l10)))))))
          (local.set $l3
            (i32.add
              (local.get $l1)
              (local.get $l3)))
          (br_if $L30
            (i32.gt_u
              (local.get $l8)
              (i32.and
                (local.tee $l2
                  (i32.add
                    (local.get $l2)
                    (i32.const 1)))
                (i32.const 65535))))))
      (i32.store16 offset=64
        (local.get $l0)
        (local.get $l1)))
    (local.set $l16
      (f64.div
        (f64.convert_i64_u
          (local.get $l14))
        (f64.const 0x1.f4p+9 (;=1000;))))
    (if $I32
      (i32.and
        (local.tee $l6
          (i32.load offset=32
            (local.get $l0)))
        (i32.const 1))
      (then
        (local.set $l2
          (i32.load
            (i32.const 824)))
        (local.set $l1
          (i32.const 0))
        (loop $L33
          (local.set $l4
            (i32.and
              (local.get $l1)
              (i32.const 65535)))
          (local.set $l1
            (i32.add
              (local.get $l1)
              (i32.const 1)))
          (br_if $L33
            (i32.gt_u
              (local.get $l2)
              (local.get $l4))))))
    (if $I34
      (i32.and
        (local.get $l6)
        (i32.const 2))
      (then
        (local.set $l1
          (i32.const 0))
        (local.set $l2
          (i32.load
            (i32.const 824)))
        (loop $L35
          (local.set $l4
            (i32.and
              (local.get $l1)
              (i32.const 65535)))
          (local.set $l1
            (i32.add
              (local.get $l1)
              (i32.const 1)))
          (br_if $L35
            (i32.gt_u
              (local.get $l2)
              (local.get $l4))))))
    (local.set $l1
      (i32.const 0))
    (local.set $l5
      (i32.load
        (i32.const 824)))
    (if $I36
      (i32.and
        (local.get $l6)
        (i32.const 4))
      (then
        (loop $L37
          (local.set $l4
            (i32.and
              (local.get $l1)
              (i32.const 65535)))
          (local.set $l1
            (i32.add
              (local.get $l1)
              (i32.const 1)))
          (br_if $L37
            (i32.gt_u
              (local.get $l5)
              (local.get $l4))))))
    (local.set $l2
      (select
        (i32.const -1)
        (i32.const 0)
        (f64.lt
          (local.get $l16)
          (f64.const 0x1.4p+3 (;=10;)))))
    (local.set $l1
      (i32.const 0))
    (loop $L38
      (local.set $l4
        (i32.and
          (local.get $l1)
          (i32.const 65535)))
      (local.set $l1
        (i32.add
          (local.get $l1)
          (i32.const 1)))
      (br_if $L38
        (i32.gt_u
          (local.get $l5)
          (local.get $l4))))
    (i32.store8
      (local.get $l13)
      (i32.const 0))
    (if $I39
      (i32.eq
        (i32.and
          (local.get $l3)
          (i32.const 65535))
        (i32.and
          (local.get $l2)
          (i32.const 65535)))
      (then
        (local.set $l15
          (f32.demote_f64
            (f64.div
              (f64.convert_i32_u
                (i32.mul
                  (i32.load offset=28
                    (local.get $l0))
                  (i32.load
                    (i32.const 824))))
              (f64.div
                (f64.convert_i64_u
                  (local.get $l14))
                (f64.const 0x1.f4p+9 (;=1000;))))))))
    (global.set $g0
      (i32.add
        (local.get $l0)
        (i32.const 80)))
    (local.get $l15))
  (func $f5 (type $t6) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (result i32)
    (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32)
    (block $B0
      (if $I1
        (local.get $p0)
        (then
          (local.set $l16
            (i32.or
              (local.get $p4)
              (i32.const -4096)))
          (local.set $l10
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l7
            (local.get $p2))
          (loop $L2
            (local.set $l5
              (local.get $p0))
            (local.set $l6
              (local.get $l7))
            (loop $L3
              (i32.store16
                (local.get $l6)
                (i32.add
                  (i32.load16_u
                    (local.get $l6))
                  (local.get $p4)))
              (local.set $l6
                (i32.add
                  (local.get $l6)
                  (i32.const 2)))
              (br_if $L3
                (local.tee $l5
                  (i32.add
                    (local.get $l5)
                    (i32.const -1)))))
            (local.set $l7
              (i32.add
                (local.get $l7)
                (local.get $l10)))
            (br_if $L2
              (i32.ne
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l10
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l12
            (i32.shl
              (local.get $p0)
              (i32.const 2)))
          (local.set $l11
            (local.get $p2))
          (local.set $l8
            (local.get $p1))
          (loop $L4
            (local.set $l7
              (local.get $p0))
            (local.set $l6
              (local.get $l11))
            (local.set $l5
              (local.get $l8))
            (loop $L5
              (i32.store
                (local.get $l5)
                (i32.mul
                  (i32.load16_s
                    (local.get $l6))
                  (local.get $p4)))
              (local.set $l6
                (i32.add
                  (local.get $l6)
                  (i32.const 2)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (br_if $L5
                (local.tee $l7
                  (i32.add
                    (local.get $l7)
                    (i32.const -1)))))
            (local.set $l11
              (i32.add
                (local.get $l10)
                (local.get $l11)))
            (local.set $l8
              (i32.add
                (local.get $l8)
                (local.get $l12)))
            (br_if $L4
              (i32.ne
                (local.tee $l9
                  (i32.add
                    (local.get $l9)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l13
            (i32.shl
              (local.get $p0)
              (i32.const 2)))
          (local.set $l10
            (local.get $p1))
          (local.set $l12
            (i32.const 0))
          (local.set $l8
            (i32.const 0))
          (local.set $l7
            (i32.const 0))
          (local.set $l9
            (i32.const 0))
          (loop $L6
            (local.set $l11
              (local.get $p0))
            (local.set $l5
              (local.get $l10))
            (loop $L7
              (local.set $l9
                (select
                  (i32.const 0)
                  (local.tee $l9
                    (i32.add
                      (local.tee $l6
                        (i32.load
                          (local.get $l5)))
                      (local.get $l9)))
                  (local.tee $l14
                    (i32.gt_s
                      (local.get $l9)
                      (local.get $l16)))))
              (local.set $l8
                (i32.add
                  (select
                    (i32.const 10)
                    (i32.gt_s
                      (local.get $l6)
                      (local.get $l7))
                    (local.get $l14))
                  (local.get $l8)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (local.set $l7
                (local.get $l6))
              (br_if $L7
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const -1)))))
            (local.set $l10
              (i32.add
                (local.get $l10)
                (local.get $l13)))
            (br_if $L6
              (i32.ne
                (local.tee $l12
                  (i32.add
                    (local.get $l12)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l10
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l14
            (call $f12
              (i32.shr_s
                (i32.shl
                  (local.get $l8)
                  (i32.const 16))
                (i32.const 16))
              (i32.const 0)))
          (local.set $l8
            (local.get $p2))
          (local.set $l9
            (i32.const 0))
          (loop $L8
            (i32.store
              (local.tee $l12
                (i32.add
                  (local.get $p1)
                  (i32.shl
                    (local.get $l9)
                    (i32.const 2))))
              (i32.const 0))
            (local.set $l6
              (local.get $p3))
            (local.set $l11
              (local.get $p0))
            (local.set $l5
              (local.get $l8))
            (local.set $l7
              (i32.const 0))
            (loop $L9
              (local.set $l7
                (i32.add
                  (i32.mul
                    (i32.load16_s
                      (local.get $l6))
                    (i32.load16_s
                      (local.get $l5)))
                  (local.get $l7)))
              (local.set $l6
                (i32.add
                  (local.get $l6)
                  (i32.const 2)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 2)))
              (br_if $L9
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const -1)))))
            (i32.store
              (local.get $l12)
              (local.get $l7))
            (local.set $l8
              (i32.add
                (local.get $l8)
                (local.get $l10)))
            (br_if $L8
              (i32.ne
                (local.tee $l9
                  (i32.add
                    (local.get $l9)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l13
            (i32.shl
              (local.get $p0)
              (i32.const 2)))
          (local.set $l10
            (local.get $p1))
          (local.set $l12
            (i32.const 0))
          (local.set $l9
            (i32.const 0))
          (local.set $l7
            (i32.const 0))
          (local.set $l8
            (i32.const 0))
          (loop $L10
            (local.set $l11
              (local.get $p0))
            (local.set $l5
              (local.get $l10))
            (loop $L11
              (local.set $l8
                (select
                  (i32.const 0)
                  (local.tee $l8
                    (i32.add
                      (local.tee $l6
                        (i32.load
                          (local.get $l5)))
                      (local.get $l8)))
                  (local.tee $l15
                    (i32.gt_s
                      (local.get $l8)
                      (local.get $l16)))))
              (local.set $l9
                (i32.add
                  (select
                    (i32.const 10)
                    (i32.gt_s
                      (local.get $l6)
                      (local.get $l7))
                    (local.get $l15))
                  (local.get $l9)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (local.set $l7
                (local.get $l6))
              (br_if $L11
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const -1)))))
            (local.set $l10
              (i32.add
                (local.get $l10)
                (local.get $l13)))
            (br_if $L10
              (i32.ne
                (local.tee $l12
                  (i32.add
                    (local.get $l12)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l13
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l10
            (i32.const 0))
          (local.set $l14
            (call $f12
              (i32.shr_s
                (i32.shl
                  (local.get $l9)
                  (i32.const 16))
                (i32.const 16))
              (local.get $l14)))
          (local.set $l12
            (local.get $p2))
          (loop $L12
            (local.set $l15
              (i32.mul
                (local.get $p0)
                (local.get $l10)))
            (local.set $l9
              (local.get $p3))
            (local.set $l8
              (i32.const 0))
            (loop $L13
              (local.set $l7
                (i32.const 0))
              (i32.store
                (local.tee $l17
                  (i32.add
                    (local.get $p1)
                    (i32.shl
                      (i32.add
                        (local.get $l8)
                        (local.get $l15))
                      (i32.const 2))))
                (i32.const 0))
              (local.set $l11
                (local.get $p0))
              (local.set $l6
                (local.get $l12))
              (local.set $l5
                (local.get $l9))
              (loop $L14
                (local.set $l7
                  (i32.add
                    (i32.mul
                      (i32.load16_s
                        (local.get $l5))
                      (i32.load16_s
                        (local.get $l6)))
                    (local.get $l7)))
                (local.set $l6
                  (i32.add
                    (local.get $l6)
                    (i32.const 2)))
                (local.set $l5
                  (i32.add
                    (local.get $l5)
                    (local.get $l13)))
                (br_if $L14
                  (local.tee $l11
                    (i32.add
                      (local.get $l11)
                      (i32.const -1)))))
              (i32.store
                (local.get $l17)
                (local.get $l7))
              (local.set $l9
                (i32.add
                  (local.get $l9)
                  (i32.const 2)))
              (br_if $L13
                (i32.ne
                  (local.tee $l8
                    (i32.add
                      (local.get $l8)
                      (i32.const 1)))
                  (local.get $p0))))
            (local.set $l12
              (i32.add
                (local.get $l12)
                (local.get $l13)))
            (br_if $L12
              (i32.ne
                (local.tee $l10
                  (i32.add
                    (local.get $l10)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l13
            (i32.shl
              (local.get $p0)
              (i32.const 2)))
          (local.set $l10
            (local.get $p1))
          (local.set $l12
            (i32.const 0))
          (local.set $l8
            (i32.const 0))
          (local.set $l7
            (i32.const 0))
          (local.set $l9
            (i32.const 0))
          (loop $L15
            (local.set $l11
              (local.get $p0))
            (local.set $l5
              (local.get $l10))
            (loop $L16
              (local.set $l9
                (select
                  (i32.const 0)
                  (local.tee $l9
                    (i32.add
                      (local.tee $l6
                        (i32.load
                          (local.get $l5)))
                      (local.get $l9)))
                  (local.tee $l15
                    (i32.gt_s
                      (local.get $l9)
                      (local.get $l16)))))
              (local.set $l8
                (i32.add
                  (select
                    (i32.const 10)
                    (i32.gt_s
                      (local.get $l6)
                      (local.get $l7))
                    (local.get $l15))
                  (local.get $l8)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (local.set $l7
                (local.get $l6))
              (br_if $L16
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const -1)))))
            (local.set $l10
              (i32.add
                (local.get $l10)
                (local.get $l13)))
            (br_if $L15
              (i32.ne
                (local.tee $l12
                  (i32.add
                    (local.get $l12)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l13
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l12
            (i32.const 0))
          (local.set $l14
            (call $f12
              (i32.shr_s
                (i32.shl
                  (local.get $l8)
                  (i32.const 16))
                (i32.const 16))
              (local.get $l14)))
          (local.set $l9
            (local.get $p2))
          (loop $L17
            (local.set $l15
              (i32.mul
                (local.get $p0)
                (local.get $l12)))
            (local.set $l8
              (local.get $p3))
            (local.set $l10
              (i32.const 0))
            (loop $L18
              (local.set $l7
                (i32.const 0))
              (i32.store
                (local.tee $l17
                  (i32.add
                    (local.get $p1)
                    (i32.shl
                      (i32.add
                        (local.get $l10)
                        (local.get $l15))
                      (i32.const 2))))
                (i32.const 0))
              (local.set $l11
                (local.get $p0))
              (local.set $l6
                (local.get $l9))
              (local.set $l5
                (local.get $l8))
              (loop $L19
                (local.set $l7
                  (i32.add
                    (local.get $l7)
                    (i32.mul
                      (i32.and
                        (i32.shr_u
                          (local.tee $l7
                            (i32.mul
                              (i32.load16_u
                                (local.get $l5))
                              (i32.load16_u
                                (local.get $l6))))
                          (i32.const 2))
                        (i32.const 15))
                      (i32.and
                        (i32.shr_u
                          (local.get $l7)
                          (i32.const 5))
                        (i32.const 127)))))
                (local.set $l6
                  (i32.add
                    (local.get $l6)
                    (i32.const 2)))
                (local.set $l5
                  (i32.add
                    (local.get $l5)
                    (local.get $l13)))
                (br_if $L19
                  (local.tee $l11
                    (i32.add
                      (local.get $l11)
                      (i32.const -1)))))
              (i32.store
                (local.get $l17)
                (local.get $l7))
              (local.set $l8
                (i32.add
                  (local.get $l8)
                  (i32.const 2)))
              (br_if $L18
                (i32.ne
                  (local.tee $l10
                    (i32.add
                      (local.get $l10)
                      (i32.const 1)))
                  (local.get $p0))))
            (local.set $l9
              (i32.add
                (local.get $l9)
                (local.get $l13)))
            (br_if $L17
              (i32.ne
                (local.tee $l12
                  (i32.add
                    (local.get $l12)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $l6
            (i32.shl
              (local.get $p0)
              (i32.const 2)))
          (local.set $l10
            (i32.const 0))
          (local.set $l8
            (i32.const 0))
          (local.set $l7
            (i32.const 0))
          (local.set $l9
            (i32.const 0))
          (loop $L20
            (local.set $l11
              (local.get $p0))
            (local.set $l5
              (local.get $p1))
            (loop $L21
              (local.set $l9
                (select
                  (i32.const 0)
                  (local.tee $l9
                    (i32.add
                      (local.tee $p3
                        (i32.load
                          (local.get $l5)))
                      (local.get $l9)))
                  (local.tee $l12
                    (i32.gt_s
                      (local.get $l9)
                      (local.get $l16)))))
              (local.set $l8
                (i32.add
                  (select
                    (i32.const 10)
                    (i32.gt_s
                      (local.get $p3)
                      (local.get $l7))
                    (local.get $l12))
                  (local.get $l8)))
              (local.set $l5
                (i32.add
                  (local.get $l5)
                  (i32.const 4)))
              (local.set $l7
                (local.get $p3))
              (br_if $L21
                (local.tee $l11
                  (i32.add
                    (local.get $l11)
                    (i32.const -1)))))
            (local.set $p1
              (i32.add
                (local.get $p1)
                (local.get $l6)))
            (br_if $L20
              (i32.ne
                (local.tee $l10
                  (i32.add
                    (local.get $l10)
                    (i32.const 1)))
                (local.get $p0))))
          (local.set $p1
            (i32.shl
              (local.get $p0)
              (i32.const 1)))
          (local.set $l7
            (i32.const 0))
          (local.set $l8
            (call $f12
              (i32.shr_s
                (i32.shl
                  (local.get $l8)
                  (i32.const 16))
                (i32.const 16))
              (local.get $l14)))
          (loop $L22
            (local.set $l5
              (local.get $p0))
            (local.set $l6
              (local.get $p2))
            (loop $L23
              (i32.store16
                (local.get $l6)
                (i32.sub
                  (i32.load16_u
                    (local.get $l6))
                  (local.get $p4)))
              (local.set $l6
                (i32.add
                  (local.get $l6)
                  (i32.const 2)))
              (br_if $L23
                (local.tee $l5
                  (i32.add
                    (local.get $l5)
                    (i32.const -1)))))
            (local.set $p2
              (i32.add
                (local.get $p1)
                (local.get $p2)))
            (br_if $L22
              (i32.ne
                (local.tee $l7
                  (i32.add
                    (local.get $l7)
                    (i32.const 1)))
                (local.get $p0))))
          (br $B0)))
      (local.set $l8
        (call $f12
          (i32.const 0)
          (call $f12
            (i32.const 0)
            (call $f12
              (i32.const 0)
              (call $f12
                (i32.const 0)
                (i32.const 0)))))))
    (i32.shr_s
      (i32.shl
        (local.get $l8)
        (i32.const 16))
      (i32.const 16)))
  (func $f6 (type $t4) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32)
    (block $B0
      (if $I1
        (i32.eqz
          (local.get $p0))
        (then
          (local.set $l4
            (i32.const -1))
          (br $B0)))
      (local.set $l5
        (i32.const -1))
      (local.set $l6
        (i32.const 8))
      (loop $L2
        (i32.mul
          (local.get $l6)
          (i32.add
            (local.get $l5)
            (i32.const 2)))
        (local.set $l6
          (i32.add
            (local.get $l6)
            (i32.const 8)))
        (local.set $l5
          (local.tee $l4
            (i32.add
              (local.get $l5)
              (i32.const 1))))
        (local.get $p0)
        (br_if $L2
          (i32.lt_u))))
    (local.set $l10
      (i32.add
        (local.tee $l7
          (i32.and
            (i32.add
              (local.get $p1)
              (i32.const 3))
            (i32.const -4)))
        (i32.shl
          (local.tee $l9
            (i32.mul
              (local.get $l4)
              (local.get $l4)))
          (i32.const 1))))
    (if $I3
      (local.get $l4)
      (then
        (local.set $p0
          (select
            (local.get $p2)
            (i32.const 1)
            (local.get $p2)))
        (local.set $l11
          (i32.shl
            (local.get $l4)
            (i32.const 1)))
        (local.set $l12
          (i32.shl
            (local.get $l9)
            (i32.const 1)))
        (local.set $p2
          (local.get $l7))
        (local.set $p1
          (i32.const 1))
        (loop $L4
          (local.set $l8
            (i32.shl
              (local.get $p1)
              (i32.const 1)))
          (local.set $l5
            (local.get $p2))
          (local.set $l6
            (i32.const 0))
          (loop $L5
            (i32.store16
              (i32.add
                (local.get $l5)
                (local.get $l12))
              (i32.add
                (local.tee $l13
                  (i32.add
                    (local.get $p1)
                    (local.get $l6)))
                (local.tee $p0
                  (i32.rem_s
                    (i32.mul
                      (local.get $p0)
                      (local.get $l13))
                    (i32.const 65536)))))
            (i32.store16
              (local.get $l5)
              (i32.and
                (i32.add
                  (local.get $p0)
                  (local.get $l8))
                (i32.const 255)))
            (local.set $l8
              (i32.add
                (local.get $l8)
                (i32.const 2)))
            (local.set $l5
              (i32.add
                (local.get $l5)
                (i32.const 2)))
            (br_if $L5
              (i32.ne
                (local.get $l4)
                (local.tee $l6
                  (i32.add
                    (local.get $l6)
                    (i32.const 1))))))
          (local.set $p1
            (i32.add
              (local.get $p1)
              (local.get $l6)))
          (local.set $p2
            (i32.add
              (local.get $p2)
              (local.get $l11)))
          (br_if $L4
            (i32.ne
              (local.tee $l14
                (i32.add
                  (local.get $l14)
                  (i32.const 1)))
              (local.get $l4))))))
    (i32.store offset=8
      (local.get $p3)
      (local.get $l10))
    (i32.store offset=4
      (local.get $p3)
      (local.get $l7))
    (i32.store
      (local.get $p3)
      (local.get $l4))
    (i32.store offset=12
      (local.get $p3)
      (i32.and
        (i32.add
          (i32.add
            (local.get $l10)
            (i32.shl
              (local.get $l9)
              (i32.const 1)))
          (i32.const 3))
        (i32.const -4))))
  (func $f7 (type $t7) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (param $p4 i32) (param $p5 i32) (result i32)
    (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (global.set $g0
      (local.tee $l6
        (i32.sub
          (global.get $g0)
          (i32.const 80))))
    (i64.store
      (i32.add
        (local.get $l6)
        (i32.const 32))
      (i64.const 0))
    (i64.store
      (i32.add
        (local.get $l6)
        (i32.const 40))
      (i64.const 0))
    (i64.store
      (i32.sub
        (local.get $l6)
        (i32.const -64))
      (i64.const 0))
    (i64.store
      (i32.add
        (local.get $l6)
        (i32.const 72))
      (i64.const 0))
    (i64.store offset=48
      (local.get $l6)
      (i64.const 0))
    (i64.store offset=56
      (local.get $l6)
      (i64.const 0))
    (i64.store offset=16
      (local.get $l6)
      (i64.const 0))
    (i64.store offset=24
      (local.get $l6)
      (i64.const 0))
    (i32.store offset=12
      (local.get $l6)
      (local.get $p1))
    (if $I0
      (i32.load8_u
        (local.get $p1))
      (then
        (loop $L1
          (i32.store
            (local.tee $l7
              (i32.add
                (i32.add
                  (local.get $l6)
                  (i32.const 48))
                (i32.shl
                  (call $f8
                    (i32.add
                      (local.get $l6)
                      (i32.const 12))
                    (i32.add
                      (local.get $l6)
                      (i32.const 16)))
                  (i32.const 2))))
            (i32.add
              (i32.load
                (local.get $l7))
              (i32.const 1)))
          (br_if $L1
            (i32.load8_u
              (i32.load offset=12
                (local.get $l6)))))))
    (i32.store offset=12
      (local.get $l6)
      (local.get $p1))
    (local.set $l8
      (i32.add
        (local.get $p0)
        (local.get $p1)))
    (if $I2
      (i32.ge_s
        (local.get $p0)
        (i32.const 1))
      (then
        (local.set $l7
          (local.get $p1))
        (loop $L3
          (if $I4
            (i32.ne
              (local.tee $l9
                (i32.load8_u
                  (local.get $l7)))
              (i32.const 44))
            (then
              (i32.store8
                (local.get $l7)
                (i32.xor
                  (local.get $p2)
                  (local.get $l9)))))
          (i32.store offset=12
            (local.get $l6)
            (local.tee $l7
              (i32.add
                (local.get $p4)
                (local.get $l7))))
          (br_if $L3
            (i32.lt_u
              (local.get $l7)
              (local.get $l8))))))
    (i32.store offset=12
      (local.get $l6)
      (local.get $p1))
    (if $I5
      (i32.load8_u
        (local.get $p1))
      (then
        (loop $L6
          (i32.store
            (local.tee $p2
              (i32.add
                (i32.add
                  (local.get $l6)
                  (i32.const 48))
                (i32.shl
                  (call $f8
                    (i32.add
                      (local.get $l6)
                      (i32.const 12))
                    (i32.add
                      (local.get $l6)
                      (i32.const 16)))
                  (i32.const 2))))
            (i32.add
              (i32.load
                (local.get $p2))
              (i32.const 1)))
          (br_if $L6
            (i32.load8_u
              (i32.load offset=12
                (local.get $l6)))))))
    (i32.store offset=12
      (local.get $l6)
      (local.get $p1))
    (if $I7
      (i32.ge_s
        (local.get $p0)
        (i32.const 1))
      (then
        (loop $L8
          (if $I9
            (i32.ne
              (local.tee $p0
                (i32.load8_u
                  (local.get $p1)))
              (i32.const 44))
            (then
              (i32.store8
                (local.get $p1)
                (i32.xor
                  (local.get $p0)
                  (local.get $p3)))))
          (i32.store offset=12
            (local.get $l6)
            (local.tee $p1
              (i32.add
                (local.get $p1)
                (local.get $p4))))
          (br_if $L8
            (i32.lt_u
              (local.get $p1)
              (local.get $l8))))))
    (local.set $p0
      (call $f11
        (i32.load offset=48
          (local.get $l6))
        (local.get $p5)))
    (local.set $p0
      (call $f11
        (i32.load offset=16
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=52
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=20
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=56
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=24
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=60
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=28
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=64
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=32
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=68
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=36
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=72
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=40
          (local.get $l6))
        (local.get $p0)))
    (local.set $p0
      (call $f11
        (i32.load offset=76
          (local.get $l6))
        (local.get $p0)))
    (call $f11
      (i32.load offset=44
        (local.get $l6))
      (local.get $p0))
    (global.set $g0
      (i32.add
        (local.get $l6)
        (i32.const 80))))
  (func $f8 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (if $I0
      (i32.eqz
        (local.tee $l3
          (i32.load8_u
            (local.tee $l4
              (i32.load
                (local.get $p0))))))
      (then
        (i32.store
          (local.get $p0)
          (local.get $l4))
        (return
          (i32.const 0))))
    (local.set $l5
      (i32.add
        (local.get $l4)
        (i32.const 1)))
    (local.set $l6
      (i32.add
        (local.get $p1)
        (i32.const 16)))
    (local.set $l7
      (i32.add
        (local.get $p1)
        (i32.const 20)))
    (local.set $l4
      (i32.add
        (local.get $p1)
        (i32.const 12)))
    (local.set $l8
      (i32.add
        (local.get $p1)
        (i32.const 4)))
    (block $B1
      (loop $L2
        (br_if $B1
          (i32.eq
            (local.get $l3)
            (i32.const 44)))
        (block $B3
          (block $B4
            (block $B5
              (block $B6
                (block $B7
                  (block $B8
                    (block $B9
                      (block $B10
                        (block $B11
                          (block $B12
                            (br_table $B12 $B3 $B11 $B8 $B10 $B9 $B7 $B6 $B3
                              (local.get $l2)))
                          (local.set $l2
                            (i32.const 4))
                          (block $B13
                            (br_if $B13
                              (i32.lt_u
                                (i32.and
                                  (i32.add
                                    (local.get $l3)
                                    (i32.const -48))
                                  (i32.const 255))
                                (i32.const 10)))
                            (local.set $l2
                              (i32.const 2))
                            (block $B14
                              (block $B15
                                (br_table $B13 $B14 $B13 $B15 $B14
                                  (i32.add
                                    (local.get $l3)
                                    (i32.const -43))))
                              (local.set $l2
                                (i32.const 5))
                              (br $B13))
                            (local.set $l2
                              (i32.const 1))
                            (i32.store
                              (local.get $l8)
                              (i32.add
                                (i32.load
                                  (local.get $l8))
                                (i32.const 1))))
                          (i32.store
                            (local.get $p1)
                            (i32.add
                              (i32.load
                                (local.get $p1))
                              (i32.const 1)))
                          (br $B3))
                        (br_if $B4
                          (i32.gt_u
                            (i32.and
                              (i32.add
                                (local.get $l3)
                                (i32.const -48))
                              (i32.const 255))
                            (i32.const 9)))
                        (i32.store offset=8
                          (local.get $p1)
                          (i32.add
                            (i32.load offset=8
                              (local.get $p1))
                            (i32.const 1)))
                        (local.set $l2
                          (i32.const 4))
                        (br $B3))
                      (if $I16
                        (i32.eq
                          (local.get $l3)
                          (i32.const 46))
                        (then
                          (i32.store
                            (local.get $l6)
                            (i32.add
                              (i32.load
                                (local.get $l6))
                              (i32.const 1)))
                          (local.set $l2
                            (i32.const 5))
                          (br $B3)))
                      (local.set $l2
                        (i32.const 4))
                      (br_if $B3
                        (i32.le_u
                          (i32.and
                            (i32.add
                              (local.get $l3)
                              (i32.const -48))
                            (i32.const 255))
                          (i32.const 9)))
                      (local.set $l4
                        (local.get $l6))
                      (br $B5))
                    (if $I17
                      (i32.eq
                        (i32.or
                          (local.get $l3)
                          (i32.const 32))
                        (i32.const 101))
                      (then
                        (i32.store
                          (local.get $l7)
                          (i32.add
                            (i32.load
                              (local.get $l7))
                            (i32.const 1)))
                        (local.set $l2
                          (i32.const 3))
                        (br $B3)))
                    (local.set $l2
                      (i32.const 5))
                    (br_if $B3
                      (i32.le_u
                        (i32.and
                          (i32.add
                            (local.get $l3)
                            (i32.const -48))
                          (i32.const 255))
                        (i32.const 9)))
                    (local.set $l4
                      (local.get $l7))
                    (br $B5))
                  (block $B18
                    (br_table $B18 $B5 $B18 $B5
                      (i32.add
                        (local.get $l3)
                        (i32.const -43))))
                  (i32.store
                    (local.get $l4)
                    (i32.add
                      (i32.load
                        (local.get $l4))
                      (i32.const 1)))
                  (local.set $l2
                    (i32.const 6))
                  (br $B3))
                (i32.store offset=24
                  (local.get $p1)
                  (i32.add
                    (i32.load offset=24
                      (local.get $p1))
                    (i32.const 1)))
                (local.set $l2
                  (select
                    (i32.const 1)
                    (i32.const 7)
                    (i32.gt_u
                      (i32.and
                        (i32.add
                          (local.get $l3)
                          (i32.const -48))
                        (i32.const 255))
                      (i32.const 9))))
                (br $B3))
              (local.set $l2
                (i32.const 7))
              (br_if $B3
                (i32.lt_u
                  (i32.and
                    (i32.add
                      (local.get $l3)
                      (i32.const -48))
                    (i32.const 255))
                  (i32.const 10)))
              (local.set $l4
                (local.get $l8)))
            (i32.store
              (local.get $l4)
              (i32.add
                (i32.load
                  (local.get $l4))
                (i32.const 1)))
            (i32.store
              (local.get $p0)
              (local.get $l5))
            (return
              (i32.const 1)))
          (i32.store offset=8
            (local.get $p1)
            (i32.add
              (i32.load offset=8
                (local.get $p1))
              (i32.const 1)))
          (local.set $l2
            (select
              (i32.const 5)
              (i32.const 1)
              (i32.eq
                (local.get $l3)
                (i32.const 46)))))
        (local.set $l9
          (i32.add
            (local.get $l5)
            (i32.const 1)))
        (if $I19
          (i32.ne
            (local.get $l2)
            (i32.const 1))
          (then
            (local.set $l3
              (i32.load8_u
                (local.get $l5)))
            (local.set $l5
              (local.get $l9))
            (br_if $L2
              (local.get $l3)))))
      (local.set $l5
        (i32.add
          (local.get $l9)
          (i32.const -1))))
    (i32.store
      (local.get $p0)
      (local.get $l5))
    (local.get $l2))
  (func $f9 (type $t3) (param $p0 i32) (param $p1 i32) (param $p2 i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32)
    (if $I0
      (i32.ge_u
        (local.tee $l8
          (i32.add
            (local.get $p0)
            (i32.const -1)))
        (i32.const 2))
      (then
        (loop $L1
          (if $I2
            (local.get $l4)
            (then
              (local.set $l6
                (i32.add
                  (local.get $p2)
                  (local.get $l3)))
              (local.set $l7
                (local.get $l4))
              (loop $L3
                (i32.store8
                  (local.get $l6)
                  (i32.load8_u
                    (local.get $l5)))
                (local.set $l5
                  (i32.add
                    (local.get $l5)
                    (i32.const 1)))
                (local.set $l6
                  (i32.add
                    (local.get $l6)
                    (i32.const 1)))
                (br_if $L3
                  (local.tee $l7
                    (i32.add
                      (local.get $l7)
                      (i32.const -1)))))
              (i32.store8
                (i32.add
                  (i32.add
                    (local.get $p2)
                    (local.get $l3))
                  (local.get $l4))
                (i32.const 44))
              (local.set $l3
                (i32.add
                  (i32.add
                    (local.get $l3)
                    (local.get $l4))
                  (i32.const 1)))))
          (local.set $l5
            (i32.load
              (i32.add
                (i32.load
                  (i32.add
                    (local.tee $l4
                      (i32.shl
                        (i32.and
                          (local.tee $p1
                            (i32.add
                              (local.get $p1)
                              (i32.const 1)))
                          (i32.const 7))
                        (i32.const 2)))
                    (i32.const 736)))
                (i32.and
                  (i32.shr_u
                    (local.get $p1)
                    (i32.const 1))
                  (i32.const 12)))))
          (br_if $L1
            (i32.lt_u
              (i32.add
                (i32.add
                  (local.get $l3)
                  (local.tee $l4
                    (i32.load
                      (i32.add
                        (local.get $l4)
                        (i32.const 768)))))
                (i32.const 1))
              (local.get $l8))))))
    (if $I4
      (i32.lt_u
        (local.get $l3)
        (local.get $p0))
      (then
        (call $f13
          (i32.add
            (local.get $p2)
            (local.get $l3))
          (i32.sub
            (local.get $p0)
            (local.get $l3))))))
  (func $f10 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i32)
    (select
      (local.tee $l2
        (i32.and
          (i32.shr_u
            (local.tee $p1
              (select
                (i32.xor
                  (local.tee $l2
                    (i32.and
                      (i32.shr_u
                        (local.tee $p1
                          (select
                            (i32.xor
                              (local.tee $l2
                                (i32.and
                                  (i32.shr_u
                                    (local.tee $p1
                                      (select
                                        (i32.xor
                                          (local.tee $l2
                                            (i32.and
                                              (i32.shr_u
                                                (local.tee $p1
                                                  (select
                                                    (i32.xor
                                                      (local.tee $l2
                                                        (i32.and
                                                          (i32.shr_u
                                                            (local.tee $p1
                                                              (select
                                                                (i32.xor
                                                                  (local.tee $l2
                                                                    (i32.and
                                                                      (i32.shr_u
                                                                        (local.tee $p1
                                                                          (select
                                                                            (i32.xor
                                                                              (local.tee $l2
                                                                                (i32.and
                                                                                  (i32.shr_u
                                                                                    (local.tee $p1
                                                                                      (select
                                                                                        (i32.xor
                                                                                          (local.tee $l2
                                                                                            (i32.and
                                                                                              (i32.shr_u
                                                                                                (local.tee $p1
                                                                                                  (select
                                                                                                    (local.tee $l3
                                                                                                      (i32.and
                                                                                                        (i32.shr_u
                                                                                                          (local.tee $l2
                                                                                                            (select
                                                                                                              (i32.xor
                                                                                                                (local.tee $l3
                                                                                                                  (i32.and
                                                                                                                    (i32.shr_u
                                                                                                                      (local.tee $l2
                                                                                                                        (select
                                                                                                                          (i32.xor
                                                                                                                            (local.tee $l3
                                                                                                                              (i32.and
                                                                                                                                (i32.shr_u
                                                                                                                                  (local.tee $l2
                                                                                                                                    (select
                                                                                                                                      (i32.xor
                                                                                                                                        (local.tee $l3
                                                                                                                                          (i32.and
                                                                                                                                            (i32.shr_u
                                                                                                                                              (local.tee $l2
                                                                                                                                                (select
                                                                                                                                                  (i32.xor
                                                                                                                                                    (local.tee $l3
                                                                                                                                                      (i32.and
                                                                                                                                                        (i32.shr_u
                                                                                                                                                          (local.tee $l2
                                                                                                                                                            (select
                                                                                                                                                              (i32.xor
                                                                                                                                                                (local.tee $l3
                                                                                                                                                                  (i32.and
                                                                                                                                                                    (i32.shr_u
                                                                                                                                                                      (local.tee $l2
                                                                                                                                                                        (select
                                                                                                                                                                          (i32.xor
                                                                                                                                                                            (local.tee $l2
                                                                                                                                                                              (i32.and
                                                                                                                                                                                (i32.shr_u
                                                                                                                                                                                  (local.tee $p1
                                                                                                                                                                                    (select
                                                                                                                                                                                      (i32.xor
                                                                                                                                                                                        (local.tee $l2
                                                                                                                                                                                          (i32.shr_u
                                                                                                                                                                                            (local.get $p1)
                                                                                                                                                                                            (i32.const 1)))
                                                                                                                                                                                        (i32.const -24575))
                                                                                                                                                                                      (local.get $l2)
                                                                                                                                                                                      (i32.and
                                                                                                                                                                                        (i32.xor
                                                                                                                                                                                          (local.get $p0)
                                                                                                                                                                                          (local.get $p1))
                                                                                                                                                                                        (i32.const 1))))
                                                                                                                                                                                  (i32.const 1))
                                                                                                                                                                                (i32.const 32767)))
                                                                                                                                                                            (i32.const -24575))
                                                                                                                                                                          (local.get $l2)
                                                                                                                                                                          (i32.and
                                                                                                                                                                            (i32.xor
                                                                                                                                                                              (local.get $p1)
                                                                                                                                                                              (i32.shr_u
                                                                                                                                                                                (local.tee $p1
                                                                                                                                                                                  (i32.and
                                                                                                                                                                                    (local.get $p0)
                                                                                                                                                                                    (i32.const 255)))
                                                                                                                                                                                (i32.const 1)))
                                                                                                                                                                            (i32.const 1))))
                                                                                                                                                                      (i32.const 1))
                                                                                                                                                                    (i32.const 32767)))
                                                                                                                                                                (i32.const -24575))
                                                                                                                                                              (local.get $l3)
                                                                                                                                                              (i32.and
                                                                                                                                                                (i32.xor
                                                                                                                                                                  (i32.shr_u
                                                                                                                                                                    (local.get $p1)
                                                                                                                                                                    (i32.const 2))
                                                                                                                                                                  (local.get $l2))
                                                                                                                                                                (i32.const 1))))
                                                                                                                                                          (i32.const 1))
                                                                                                                                                        (i32.const 32767)))
                                                                                                                                                    (i32.const -24575))
                                                                                                                                                  (local.get $l3)
                                                                                                                                                  (i32.and
                                                                                                                                                    (i32.xor
                                                                                                                                                      (i32.shr_u
                                                                                                                                                        (local.get $p1)
                                                                                                                                                        (i32.const 3))
                                                                                                                                                      (local.get $l2))
                                                                                                                                                    (i32.const 1))))
                                                                                                                                              (i32.const 1))
                                                                                                                                            (i32.const 32767)))
                                                                                                                                        (i32.const -24575))
                                                                                                                                      (local.get $l3)
                                                                                                                                      (i32.and
                                                                                                                                        (i32.xor
                                                                                                                                          (i32.shr_u
                                                                                                                                            (local.get $p1)
                                                                                                                                            (i32.const 4))
                                                                                                                                          (local.get $l2))
                                                                                                                                        (i32.const 1))))
                                                                                                                                  (i32.const 1))
                                                                                                                                (i32.const 32767)))
                                                                                                                            (i32.const -24575))
                                                                                                                          (local.get $l3)
                                                                                                                          (i32.and
                                                                                                                            (i32.xor
                                                                                                                              (i32.shr_u
                                                                                                                                (local.get $p1)
                                                                                                                                (i32.const 5))
                                                                                                                              (local.get $l2))
                                                                                                                            (i32.const 1))))
                                                                                                                      (i32.const 1))
                                                                                                                    (i32.const 32767)))
                                                                                                                (i32.const -24575))
                                                                                                              (local.get $l3)
                                                                                                              (i32.and
                                                                                                                (i32.xor
                                                                                                                  (i32.shr_u
                                                                                                                    (local.get $p1)
                                                                                                                    (i32.const 6))
                                                                                                                  (local.get $l2))
                                                                                                                (i32.const 1))))
                                                                                                          (i32.const 1))
                                                                                                        (i32.const 32767)))
                                                                                                    (i32.xor
                                                                                                      (local.get $l3)
                                                                                                      (i32.const -24575))
                                                                                                    (i32.eq
                                                                                                      (i32.and
                                                                                                        (local.get $l2)
                                                                                                        (i32.const 1))
                                                                                                      (i32.shr_u
                                                                                                        (local.get $p1)
                                                                                                        (i32.const 7)))))
                                                                                                (i32.const 1))
                                                                                              (i32.const 32767)))
                                                                                          (i32.const -24575))
                                                                                        (local.get $l2)
                                                                                        (i32.and
                                                                                          (i32.xor
                                                                                            (local.get $p1)
                                                                                            (i32.shr_u
                                                                                              (local.get $p0)
                                                                                              (i32.const 8)))
                                                                                          (i32.const 1))))
                                                                                    (i32.const 1))
                                                                                  (i32.const 32767)))
                                                                              (i32.const -24575))
                                                                            (local.get $l2)
                                                                            (i32.and
                                                                              (i32.xor
                                                                                (local.get $p1)
                                                                                (i32.shr_u
                                                                                  (local.get $p0)
                                                                                  (i32.const 9)))
                                                                              (i32.const 1))))
                                                                        (i32.const 1))
                                                                      (i32.const 32767)))
                                                                  (i32.const -24575))
                                                                (local.get $l2)
                                                                (i32.and
                                                                  (i32.xor
                                                                    (local.get $p1)
                                                                    (i32.shr_u
                                                                      (local.get $p0)
                                                                      (i32.const 10)))
                                                                  (i32.const 1))))
                                                            (i32.const 1))
                                                          (i32.const 32767)))
                                                      (i32.const -24575))
                                                    (local.get $l2)
                                                    (i32.and
                                                      (i32.xor
                                                        (local.get $p1)
                                                        (i32.shr_u
                                                          (local.get $p0)
                                                          (i32.const 11)))
                                                      (i32.const 1))))
                                                (i32.const 1))
                                              (i32.const 32767)))
                                          (i32.const -24575))
                                        (local.get $l2)
                                        (i32.and
                                          (i32.xor
                                            (local.get $p1)
                                            (i32.shr_u
                                              (local.get $p0)
                                              (i32.const 12)))
                                          (i32.const 1))))
                                    (i32.const 1))
                                  (i32.const 32767)))
                              (i32.const -24575))
                            (local.get $l2)
                            (i32.and
                              (i32.xor
                                (local.get $p1)
                                (i32.shr_u
                                  (local.get $p0)
                                  (i32.const 13)))
                              (i32.const 1))))
                        (i32.const 1))
                      (i32.const 32767)))
                  (i32.const -24575))
                (local.get $l2)
                (i32.and
                  (i32.xor
                    (local.get $p1)
                    (i32.shr_u
                      (local.get $p0)
                      (i32.const 14)))
                  (i32.const 1))))
            (i32.const 1))
          (i32.const 32767)))
      (i32.xor
        (local.get $l2)
        (i32.const 40961))
      (i32.eq
        (i32.and
          (local.get $p1)
          (i32.const 1))
        (i32.shr_u
          (local.get $p0)
          (i32.const 15)))))
  (func $f11 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (call $f10
      (i32.shr_u
        (local.get $p0)
        (i32.const 16))
      (call $f10
        (i32.and
          (local.get $p0)
          (i32.const 65535))
        (local.get $p1))))
  (func $f12 (type $t0) (param $p0 i32) (param $p1 i32) (result i32)
    (call $f10
      (i32.and
        (local.get $p0)
        (i32.const 65535))
      (local.get $p1)))
  (func $f13 (type $t2) (param $p0 i32) (param $p1 i32)
    (local $l2 i32) (local $l3 i32)
    (block $B0
      (br_if $B0
        (i32.eqz
          (local.get $p1)))
      (i32.store8
        (i32.add
          (local.tee $l2
            (i32.add
              (local.get $p0)
              (local.get $p1)))
          (i32.const -1))
        (i32.const 0))
      (i32.store8
        (local.get $p0)
        (i32.const 0))
      (br_if $B0
        (i32.lt_u
          (local.get $p1)
          (i32.const 3)))
      (i32.store8
        (i32.add
          (local.get $l2)
          (i32.const -2))
        (i32.const 0))
      (i32.store8 offset=1
        (local.get $p0)
        (i32.const 0))
      (i32.store8
        (i32.add
          (local.get $l2)
          (i32.const -3))
        (i32.const 0))
      (i32.store8 offset=2
        (local.get $p0)
        (i32.const 0))
      (br_if $B0
        (i32.lt_u
          (local.get $p1)
          (i32.const 7)))
      (i32.store8
        (i32.add
          (local.get $l2)
          (i32.const -4))
        (i32.const 0))
      (i32.store8 offset=3
        (local.get $p0)
        (i32.const 0))
      (br_if $B0
        (i32.lt_u
          (local.get $p1)
          (i32.const 9)))
      (br_if $B0
        (i32.eqz
          (local.tee $l2
            (i32.shr_u
              (i32.sub
                (local.get $p1)
                (local.tee $p1
                  (i32.and
                    (i32.sub
                      (i32.const 0)
                      (local.get $p0))
                    (i32.const 3))))
              (i32.const 2)))))
      (local.set $l2
        (i32.sub
          (i32.const 0)
          (local.get $l2)))
      (local.set $p1
        (i32.add
          (local.get $p0)
          (local.get $p1)))
      (loop $L1
        (i32.store
          (local.get $p1)
          (i32.const 0))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 4)))
        (i32.ge_u
          (local.tee $p0
            (i32.add
              (local.get $l2)
              (i32.const 1)))
          (local.get $l2))
        (local.set $l2
          (local.get $p0))
        (br_if $L1))))
  (func $f14 (type $t1)
    (i64.store
      (i32.const 2848)
      (call $env.clock_ms)))
  (func $f15 (type $t1)
    (i64.store
      (i32.const 2856)
      (call $env.clock_ms)))
  (memory $memory (export "memory") 1)
  (global $g0 (mut i32) (i32.const 512))
  (data (i32.const 512) "\b0\d4@3yj\14\e7\c1\e3R\be\99\11\08V\d7\1fG\07G^\bf9\a4\e5:\8e\84\8d\00\00`\02\00\00e\02\00\00j\02\00\00o\02\00\00t\02\00\00}\02\00\00\86\02\00\00\8f\02\00\00\98\02\00\00\a1\02\00\00\aa\02\00\00\b3\02\00\00\bc\02\00\00\c5\02\00\00\ce\02\00\00\d7\02\00\005012\001234\00-874\00+122\0035.54400\00.1234500\00-110.700\00+0.64400\005.500e+3\00-.123e-2\00-87e+832\00+0.6e-12\00T0.3e-1F\00-T.T++Tq\001T3.4e4z\0034.0e-T^\00 \02\00\00 \02\00\00 \02\00\000\02\00\000\02\00\00@\02\00\00@\02\00\00P\02\00\00\04\00\00\00\04\00\00\00\04\00\00\00\08\00\00\00\08\00\00\00\08\00\00\00\08\00\00\00\08\00\00\00\10\0b\00\00\14\0b\00\004\03\00\00\18\0b\00\00\1c\0b")
  (data (i32.const 820) "f\00\00\00\01"))

