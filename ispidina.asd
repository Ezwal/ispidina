#|
  This file is a part of ispidina project.
|#

(defsystem "ispidina"
  :version "0.1.0"
  :author "Ezwal"
  :license "IDGF"
  :depends-on (#:dexador #:plump #:lquery #:lparallel #:str)
  :components ((:module "src"
                :components
                ((:file "ispidina"))))
  :description "rakin'"
  :in-order-to ((test-op (test-op "ispidina-test"))))
