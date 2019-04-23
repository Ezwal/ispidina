;;;; ispidina.asd

(asdf:defsystem #:ispidina
  :description "rakin'"
  :author "Ezwal"
  :license  "IDGF"
  :version "0.0.1"
  :serial t
  :depends-on (#:dexador #:plump #:lquery #:lparallel #:str)
  :components ((:file "package")
               (:file "ispidina")))
