#|
  This file is a part of ispidina project.
|#

(defsystem "ispidina-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("ispidina"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "ispidina"))))
  :description "Test system for ispidina"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
