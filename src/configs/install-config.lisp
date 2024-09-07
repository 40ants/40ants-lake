(uiop:define-package #:40ants-lake/configs/install-config
  (:use #:cl)
  (:import-from #:mustache)
  (:import-from #:alexandria
                #:read-file-into-string
                #:remove-from-plistf
                #:write-string-into-file
                #:hash-table-alist
                #:plist-hash-table)
  (:import-from #:40ants-lake/errors
                #:lake-error)
  (:import-from #:40ants-lake/perform
                #:perform)
  (:import-from #:cl-ansi-text
                #:green)
  (:import-from #:serapeum
                #:fmt)
  (:export
   #:install-config))
(in-package #:40ants-lake/configs/install-config)


(defclass install-config ()
  ((template-filename :initarg :template-filename
                      :type pathname
                      :reader template-filename)
   (target-filename :initarg :target-filename
                    :type pathname
                    :reader target-filename)
   (template-vars :initarg :template-vars
                  :type hash-table
                  :reader template-vars)
   (check-func :initarg :check-func
               :type (or null function)
               :initform nil
               :reader check-func)
   (on-update-func :initarg :on-update-func
                   :type (or null function)
                   :initform nil
                   :reader on-update-func)))


(defmethod print-object ((obj install-config) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~A -> ~A"
            (namestring (template-filename obj))
            (namestring (target-filename obj)))))


(defun search-template-file (template-name)
  (let* ((filename (uiop:parse-unix-namestring template-name))
        (full-filename (asdf:system-relative-pathname
                   :40ants-lake
                   (merge-pathnames filename
                                    (make-pathname :directory
                                                   (list :relative "templates"))))))
    (cond
      ((probe-file full-filename)
       full-filename)
      (t
       (lake-error "Unable to find ~S in ~S"
              template-name
              (namestring (asdf:system-relative-pathname
                           :40ants-lake
                           (make-pathname :directory
                                          (list :relative
                                                "templates")))))))))


(defun install-config (template-name target-filename &rest template-vars
                                                     &key check-func
                                                          on-update-func
                                                     &allow-other-keys)
  (remove-from-plistf template-vars
                      :check-func
                      :on-update-func)
  (make-instance 'install-config
                 :template-filename (search-template-file template-name)
                 :target-filename target-filename
                 :template-vars (plist-hash-table template-vars)
                 :check-func check-func
                 :on-update-func on-update-func))


(defun content-is-equal (first-file second-file)
  (when (and (probe-file first-file)
             (probe-file second-file))
    (string= (read-file-into-string first-file)
             (read-file-into-string second-file))))


(defmethod perform ((step install-config))
  (let* ((tmpl (mustache:compile-template (template-filename step))))
    (write-string
     (green (fmt "Installing config to ~S~%"
                 (namestring (target-filename step)))))

    (uiop:with-temporary-file (:stream temp-file-stream
                               :pathname temp-file-path
                               :direction :output)
      (when lake::*verbose*
        (write-string
         (green (fmt "Writing config to a temp file ~S"
                     temp-file-path))))
      (funcall tmpl
               (hash-table-alist (template-vars step))
               temp-file-stream)
      ;; It is important to sync data to disk because
      ;; it should be available to external programs for checking the config.
      (finish-output temp-file-stream)


      (unless (content-is-equal temp-file-path (target-filename step))
      
        (ensure-directories-exist (target-filename step))

        (when (check-func step)
          (multiple-value-bind (config-is-ok error-message)
              (funcall (check-func step) temp-file-path)
          
            (unless config-is-ok
              (lake-error "New version of config ~S version is wrong~:[:~%~A.~;.~]"
                          (namestring (target-filename step))
                          config-is-ok
                          error-message))))

        ;; TODO: Add ability to save previous config version as a numbered backup.
      
        (lake:sh (fmt "sudo mv '~A' '~A'"
                      (namestring temp-file-path)
                      (namestring (target-filename step))))

        (when (on-update-func step)
          (funcall (on-update-func step)
                   (target-filename step))))
      
      ;; TODO: Here we'll need to set correct permissions.
      ;; TODO: Also we need to add an additional step to reload config if it was changed.
      (values t))))
