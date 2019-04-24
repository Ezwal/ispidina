(defpackage ispidina
  (:use :cl))
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

(defun fetch-imgur-gallery (url)
  (let* ((parsed-page (dl+parse-page url))
         (title (select-imgur-title parsed-page))
         (title-dir (directory-name title))
         (images (select-imgur-images parsed-page)))
    (ensure-directories-exist title-dir)
    (map 'vector
          (lambda (id) (fetch-img (format-id-to-link id)
                                        (str:concat title-dir id ".jpg")))
            images)))

;; this may or not be useful depending on the state of the network
;; (setf lparallel:*kernel* (lparallel:make-kernel 4))
;; (defun parallel-fetch-imgur-gallery (url)
;;   (let* ((parsed-page (dl+parse-page url))
;;          (title (select-imgur-title parsed-page))
;;          (title-dir (directory-name title))
;;          (images (select-imgur-images parsed-page)))
;;     (ensure-directories-exist title-dir)
;;     (lparallel:pmap 'vector
;;                     (lambda (id) (fetch-img (format-id-to-link id)
;;                                             (str:concat title-dir id ".jpg")))
;;                     images)))

(defun main ()
  (let ((argv sb-ext:*posix-argv*))
    (fetch-imgur-gallery (first argv))))