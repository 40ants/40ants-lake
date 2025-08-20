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


(defvar *default-chmod* "600")


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
   (partials :initarg :partials
             :type list
             :documentation "Alist of where key is a string name of the partial and value is a template filename."
             :reader template-partials)
   (chown :initarg :chown
          :type (or null string)
          :documentation "A user:group to chown file to. If not given, then it will belong current user."
          :reader chown-to)
   (chmod :initarg :chmod
          :type string
          :initform *default-chmod*
          :documentation "A mask like 600 to chmod file after creation. If not given, it will be 600"
          :reader chmod-to)
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
                                                          partials
                                                          (chmod *default-chmod*)
                                                          chown
                                                     &allow-other-keys)
  (remove-from-plistf template-vars
                      :check-func
                      :partials
                      :chmod
                      :chown
                      :on-update-func)
  (make-instance 'install-config
                 :partials partials
                 :chmod chmod
                 :chown chown
                 :template-filename (search-template-file template-name)
                 :target-filename target-filename
                 :template-vars (plist-hash-table template-vars)
                 :check-func check-func
                 :on-update-func on-update-func))


(defun content-is-equal (first-file second-file)
  (when (and (probe-file first-file)
             (probe-file second-file))
    (let ((exit-code (nth-value 2
                                (uiop:run-program (list "diff"
                                                        "--ignore-blank-lines"
                                                        (namestring first-file)
                                                        (namestring second-file))
                                                  :ignore-error-status t))))
      (zerop exit-code))))


(defmethod perform ((step install-config))
  (let* ((tmpl (mustache:compile-template (template-filename step)))
         (partials (loop for (name . template-filename) in (template-partials step)
                         for full-filename = (search-template-file template-filename)
                         for content = (read-file-into-string full-filename)
                         collect (cons name content))))
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
               (mustache:make-context :data (hash-table-alist (template-vars step))
                                      :partials partials)
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
      
        (let ((target-as-str (namestring (target-filename step))))
          (lake:sh (fmt "sudo mv '~A' '~A'"
                        (namestring temp-file-path)
                        target-as-str))
          (when (chown-to step)
            (lake:sh (fmt "sudo chown '~A' '~A'"
                          (chown-to step)
                          target-as-str)))
          (when (chmod-to step)
            (lake:sh (fmt "sudo chmod '~A' '~A'"
                          (chmod-to step)
                          target-as-str))))

        (when (on-update-func step)
          (funcall (on-update-func step)
                   (target-filename step))))
      
      ;; TODO: Here we'll need to set correct permissions.
      ;; TODO: Also we need to add an additional step to reload config if it was changed.
      (values t))))
