(uiop:define-package #:40ants-lake/errors
  (:use #:cl)
  (:import-from #:serapeum
                #:fmt)
  (:export #:lake-error-message
           #:lake-error))
(in-package #:40ants-lake/errors)


(define-condition lake-error (error)
  ((message :initarg :message
            :type string
            :reader lake-error-message))
  (:report (lambda (err stream)
             (write-string (lake-error-message err) stream ))))


(defun lake-error (message &rest args)
  (error 'lake-error
         :message (apply #'format
                         nil
                         message
                         args)))
