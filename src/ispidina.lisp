(defpackage ispidina
  (:use :cl)
  (:export
   :main))
(in-package :ispidina)

(defun dl+parse-page (url)
  (let ((page (dex:get url)))
    (plump:parse page)))

(defun select-imgur-title (parsed-page)
  (aref (remove-duplicates (lquery:$ parsed-page
                             "div .post-title"
                             (text))
                           :test #'equal) 0))


(defun select-imgur-images (parsed-page)
    (delete-duplicates (lquery:$ parsed-page
                         "div .post-image-container"
                         (attr :id))))

(defun directory-name (s)
  (str:concat (str:replace-all  " " "_" s) "/"))

(defun format-id-to-link (id)
  (str:concat "https://i.imgur.com/" id ".jpg"))

(defun fetch-img (url destination)
  (ignore-errors (dex:fetch url destination)))

;; perf comparison:
;; for 256jpg 1920x1080 wp
;; Serie => 56s
;; // w 4 agents => 10s
;; // w 8 agents => 4.5s

(defun fetch-imgur-gallery (url &optional is-parallel?)
  (let* ((parsed-page (dl+parse-page url))
         (title (select-imgur-title parsed-page))
         (title-dir (directory-name title))
         (images (select-imgur-images parsed-page)))
    (ensure-directories-exist title-dir)
    (if is-parallel? (setf lparallel:*kernel* (lparallel:make-kernel 4)))
    (funcall (if is-parallel? #'lparallel:pmap #'map)
             'vector
          (lambda (id) (fetch-img (format-id-to-link id)
                                        (str:concat title-dir id ".jpg")))
            images)))

(defun main ()
  (let ((argv sb-ext:*posix-argv*))
    (fetch-imgur-gallery (second argv) (third argv))))
