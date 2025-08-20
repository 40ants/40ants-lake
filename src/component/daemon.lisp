(uiop:define-package #:40ants-lake/component/daemon
  (:use #:cl)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:40ants-lake/app
                #:app-components
                #:app-name
                #:current-app)
  (:import-from #:40ants-lake/configs/install-config
                #:install-config)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:alexandria
                #:read-file-into-string
                #:positive-fixnum)
  (:import-from #:40ants-lake/utils
                #:namestring-if-exists)
  (:import-from #:40ants-lake/errors
                #:lake-error)
  (:import-from #:40ants-lake/env-val
                #:resolve-env-value)
  (:import-from #:40ants-lake/environment
                #:add-prod-suffix-if-needed
                #:add-dev-suffix-if-needed)
  (:export #:daemon
           #:has-daemon-component-p))
(in-package #:40ants-lake/component/daemon)


(defclass daemon ()
  ((environment :initarg :environment
                :type list
                :initform nil
                :reader daemon-environment)
   (user :initarg :user
         :type string
         :initform "root"
         :reader daemon-user)))


(defun daemon (&key environment
                    (user (or (uiop:getenv "USER")
                              "root")))
  (make-instance 'daemon
                 :environment environment
                 :user user))


(defun prepare-env-for-mustache (env-alist)
  (loop for (key . value) in env-alist
        for resolved-value = (resolve-env-value value)
        when resolved-value
        collect (list (cons :key key)
                      (cons :value resolved-value))))


(defmethod collect-installation-steps ((component daemon))
  (let* ((app-name (app-name (current-app)))
         (service-name (add-dev-suffix-if-needed app-name))
         (binary-name (add-prod-suffix-if-needed app-name))
         (file-to-search (make-pathname :directory '(:relative "roswell")
                                        :name binary-name))
         (app-binary (probe-file file-to-search)))

    (unless app-binary
      (lake-error "There is no binary at ~S. Build it first with 'lake build' command (and probably with 'lake to-prod' command)."
                  (namestring file-to-search)))
    
    (flet ((on-update (config-path)
             (declare (ignore config-path))
             (lake:sh "sudo systemctl daemon-reload"
                      :echo t)
             (lake:sh (fmt "sudo systemctl restart ~A"
                           service-name)
                      :echo t)))
      (list (install-config "systemd.service"
                            (uiop:parse-unix-namestring
                             (fmt "/etc/systemd/system/~A.service"
                                  service-name))
                            :chown "root"
                            :chmod "600"
                            :on-update-func #'on-update
                            ;; Args for a template
                            :user (daemon-user component)
                            :service-name service-name
                            :app-binary app-binary
                            :environment (prepare-env-for-mustache
                                          (resolve-env-value
                                           (daemon-environment component))))))))


(defun has-daemon-component-p (app)
  (some (lambda (component)
          (typep component 'daemon))
        (app-components app)))
