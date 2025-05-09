(defpackage #:org.shirakumo.parachute.example
  (:use #:cl #:parachute))
(in-package #:org.shirakumo.parachute.example)

(define-test dependency
  (false (sleep 1)))

(define-test example
  :depends-on (dependency)
  (true T)
  (false NIL)
  (is equal "A" (string :a))
  (of-type symbol 'foo)
  (is-values (values 0 "0" 'c)
    (= 0)
    (equal "1")
    (= 2)
    "This illustrates a multiple value test!"))

(define-test subtest
  :parent example
  (fail (error "An expected failure."))
  (fail (warn "An expected warning.") warning))

(define-test failing
  (true (< 8 5))
  (fail 'happy)
  (true (= 5 (read-from-string "OH-SHIT"))))

(define-test partially-correct
  (true "Happy")
  (is = (get-universal-time) 2962566000))

(define-test shuffle
  :serial NIL
  (true 1)
  (true 2)
  (true 3)
  (true 4)
  (true 5))

(define-test timeout
  :time-limit 0.5
  (sleep 0.75))

(define-test bad-dependency
  :depends-on (failing)
  (is = 5 5))

(define-test emergency-dependency
  :depends-on (:not bad-dependency)
  (true "ALARM!!"))

(define-test finish
  (finish T)
  (finish (error "NOPE")))

(define-test override
  (true T)
  (skip "Not ready yet"
    (false T)
    (is = 5 6))
  (with-forced-status (:failed)
    (false NIL)))

(define-test fixture
  :fix (*read-default-float-format*)
  (is = 0.0f0 (read-from-string "0.0"))
  (setf *read-default-float-format* 'double-float)
  (is = 0.0d0 (read-from-string "0.0")))

(define-test bad-var
  (is eql a 'c))

(define-test bad-test
  (is something 'a 'a))

(define-test kill
  :time-limit 1
  (dotimes (i 20) (sleep 0.1)))

(define-test capture
  (fail-compile (defun foo () (frob)) style-warning))
