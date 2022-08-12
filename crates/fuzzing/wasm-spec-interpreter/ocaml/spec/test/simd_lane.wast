;; Tests for the extract_lane, replace_lane, swizzle and shuffle group instructions


(module
  (func (export "f64x2_replace_lane-last") (param v128 f64) (result v128)
    (f64x2.replace_lane 0 (local.get 0) (local.get 1)))
)

(assert_return (invoke "f64x2_replace_lane-last" (v128.const f64x2 2.0 2.0) (f64.const 0.0)) (v128.const f64x2 0.0 2.0))

