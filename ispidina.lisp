;;;; ispidina.lisp

(in-package #:ispidina)

(defvar *imgur-link* "https://imgur.com/gallery/ljYIWap")
(defvar *artstation-link* "https://www.artstation.com/ivanvilmant/likes")

(defun dl+parse-page (url)
  (let ((page (dex:get url)))
    (plump:parse page)))

(defun select-imgur-title (parsed-page)
  (aref (remove-duplicates (lquery:$ parsed-page
                             "div .post-title"
                             (text))
                           :test #'equal) 0))

(defmacro select-title (lquery-sel parsed-page)
  `(aref (remove-duplicates (lquery:$ ,parsed-page
                              ,@lquery-sel)
                            :test #'equal) 0))

(defun select-imgur-images (parsed-page)
  (delete-duplicates (lquery:$ parsed-page
                       "div .post-image-container"
                       (attr :id))))

(defmacro select-images (lquery-sel parsed-page)
  `(delete-duplicates (lquery:$ ,parsed-page
                        ,@lquery-sel)))

(defun select-imgur-images (parsed-page)
  (select-images ("div .post-image-container" (attr :id))
                 parsed-page))

(defmacro replace-multiple (to-replace s)
  `(apply #'str:replace-all (,@(first to-replace)
            (if (not ,to-replace) ,s
                (replace-multiple ,(rest to-replace) ,s)))))

(defun directory-name (s)
  (str:concat (str:replace-all "/" "|" (str:replace-all  " " "_" s)) "/"))

(defun format-id-to-link (id)
  (str:concat "https://i.imgur.com/" id ".jpg"))

(defun get-formatter (form) (lambda (id)
                              (str:replace-all "{id}" id form)))

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


(defun main ()
  (let ((argv sb-ext:*posix-argv*))
    (fetch-imgur-gallery (first argv))))
