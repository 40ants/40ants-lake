(uiop:define-package #:40ants-lake/component/webservice
  (:use #:cl)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:40ants-lake/app
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
  (:export #:webservice))
(in-package #:40ants-lake/component/webservice)


(defclass webservice ()
  ((host :initarg :host
         :type string
         :reader webservice-host)
   (backend-port :initarg :backend-port
                 :type positive-fixnum
                 :reader webservice-backend-port)))


(defun webservice (host backend-port)
  (make-instance 'webservice
                 :host host
                 :backend-port backend-port))


(defun check-nginx-config (filename)

  (lake:sh "sudo rm -fr /tmp/nginx-to-test")
  (lake:sh "sudo cp -R /etc/nginx /tmp/nginx-to-test")
  (lake:sh "sudo sed -i 's/\\/etc\\/nginx\\//\\/tmp\\/nginx-to-test\\//' /tmp/nginx-to-test/nginx.conf")
  (lake:sh (fmt "sudo cp '~A' /tmp/nginx-to-test/sites-enabled/"
                (namestring filename)))
  
  (let ((command "sudo nginx -q -t -c /tmp/nginx-to-test/nginx.conf"))
    (multiple-value-bind (output error-output return-status)
        (uiop:run-program command :output :string
                                  :error-output :output
                                  :ignore-error-status t)
      (declare (ignore error-output))
      (cond
        ((zerop return-status)
         (values t))
        (t
         (cond
           (lake::*verbose*
            (values nil
                    (fmt "~2%~A~2%Content of ~S:~2%~A~%"
                         output
                         (namestring filename)
                         (read-file-into-string filename))))
           (t
            (values nil
                    output))))))))


(defmethod collect-installation-steps ((component webservice))
  (let ((app-name (app-name (current-app)))
        (host (webservice-host component))
        (port (webservice-backend-port component)))
    (flet ((on-update (config-path)
             (declare (ignore config-path))
             (lake:sh "sudo nginx -s reload"
                      :echo t)
             (lake:sh (fmt "sudo certbot --nginx -d ~A -d www.~A"
                           host host)
                      :echo t)))
      (list (install-config "nginx.conf"
                            (uiop:parse-unix-namestring
                             (fmt "/etc/nginx/sites-enabled/~A.conf"
                                  app-name))
                                                        
                            :check-func #'check-nginx-config
                            :on-update-func #'on-update
                            ;; Args for a template
                            :app-name app-name
                            :backend-port port
                            :host host
                            :ssl-certificate (namestring-if-exists
                                              (fmt "/etc/letsencrypt/live/~A/fullchain.pem"
                                                   host))
                            :ssl-certificate-key (namestring-if-exists
                                                  (fmt "/etc/letsencrypt/live/~A/privkey.pem"
                                                       host)))))))
