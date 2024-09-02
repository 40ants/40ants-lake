(uiop:define-package #:40ants-lake/utils
  (:use #:cl)
  (:export #:alias))
(in-package #:40ants-lake/utils)


(declaim (ftype (function (string string)
                          (values))
                alias))

(defun alias (alias-name existing-task-name)
  (let ((task (lake::get-task existing-task-name lake::*tasks*)))
    (unless task
      (error "Task \"~A\" not found."
             existing-task-name))
    
    (let* ((aliased-task (lake::make-task alias-name
                                          (lake::task-namespace task)
                                          (lake::task-arguments task)
                                          (lake::task-dependency task)
                                          (lake::task-description task)
                                          (lake::task-action task)))
           (cleaned-tasks (remove aliased-task lake::*tasks* :test #'lake::task=)))
      (setf lake::*tasks*
            (push aliased-task cleaned-tasks)))
    (values)))
