LISP ?= sbcl

build:
		$(LISP) --load ispidina.asd \
		--eval '(ql:quickload :ispidina)' \
		--eval '(asdf:make :ispidina)' \
		--eval '(quit)'
