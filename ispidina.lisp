;;;; ispidina.lisp

(in-package #:ispidina)

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

(defun fetch-imgur-gallery (url)
  (let* ((parsed-page (dl+parse-page url))
         (title (select-imgur-title parsed-page))
         (title-dir (directory-name title))
         (images (select-imgur-images parsed-page)))
    (ensure-directories-exist title-dir)
    (loop :for id :across images
          :collect (fetch-img (format-id-to-link id)
                              (str:concat title-dir id ".jpg")))))

(defun fetch-img (url destination)
  (ignore-errors (dex:fetch url destination)))
