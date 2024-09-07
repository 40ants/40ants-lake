(uiop:define-package #:40ants-lake/utils
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:str)
  (:export #:alias
           #:get-full-path
           #:get-system-path
           #:namestring-if-exists))
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


(declaim (ftype (function (string)
                          (values string &optional))
                get-full-path))

(defun get-full-path (path)
  "For a path like deploy/$HOME/.local/share/systemd/user/app.service
   returns deploy/.local/share/systemd/user/app.service"
  (namestring (probe-file (str:replace-all "/$HOME/"
                                           "/"
                                           path))))


(declaim (ftype (function (string)
                          (values string &optional))
                get-system-path))

(defun get-system-path (path &key (prefix "deploy/"))
    "For a path like deploy/$HOME/.local/share/systemd/user/app.service
     returns /home/username/.local/share/systemd/user/app.service"
  (unless (str:starts-with-p prefix path)
    (error "Path \"~A\" should start with \"deploy/\"."
           path))
  
  (str:replace-all "/$HOME/"
                   (namestring (user-homedir-pathname))
                   (subseq path (1- (length prefix)))))



(defun namestring-if-exists (path-or-string)
  (let ((filename (probe-file path-or-string)))
    (when filename
      (namestring filename))))
