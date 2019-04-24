#|
  This file is a part of ispidina project.
|#

(asdf:defsystem #:ispidina
  :version "0.1.0"
  :author "Ezwal"
  :license "IDGF"
  :serial t
  :depends-on (#:dexador
               #:plump
               #:lquery
               #:lparallel
               #:str)
  :components ((:module "src"
                :components
                ((:file "ispidina"))))
  :description "rakin'"
  :build-pathname "ispidina"
  :build-operation "program-op"
  :entry-point "ispidina:main")
;; :in-order-to ((test-op (test-op "ispidina-test"))
