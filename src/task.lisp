(uiop:define-package #:40ants-lake/task
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/errors
                #:lake-error-message
                #:lake-error)
  (:import-from #:cl-ansi-text
                #:red))
(in-package #:40ants-lake/task)


(defmethod lake::execute-task :around ((task t) &optional args)
  (declare (ignore args))
  ;; This wrapper is used to show to the end user only
  ;; a error message without a backtrace unless *verbose* mode is on.
  (handler-bind ((lake-error (lambda (condition)
                               (unless lake::*verbose*
                                 (write-string (red
                                                (lake-error-message condition))
                                               *error-output*)
                                 (terpri *error-output*)
                                 (uiop:quit 1)))))
    (call-next-method)))
