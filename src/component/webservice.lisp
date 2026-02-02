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
                #:required-argument
                #:read-file-into-string
                #:positive-fixnum)
  (:import-from #:40ants-lake/utils
                #:namestring-if-exists)
  (:import-from #:40ants-lake/env-val
                #:env-val
                #:resolve-env-value)
  (:import-from #:40ants-lake/environment
                #:add-dev-suffix-if-needed)
  (:export #:webservice
           #:proxy
           #:route
           #:url-prefix
           #:backend-port
           #:backend-host
           #:webservice-host
           #:webservice-routes))
(in-package #:40ants-lake/component/webservice)


(defclass webservice ()
  ((host :initarg :host
         :type string
         :reader webservice-host)
   (routes :initarg :routes
           :type list
           :reader webservice-routes)))


(defun webservice (host &key routes)
  (make-instance 'webservice
                 :host host
                 :routes (uiop:ensure-list routes)))


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
        (host (resolve-env-value (webservice-host component))))
    (flet ((on-update (config-path)
             (declare (ignore config-path))
             (lake:sh "sudo nginx -s reload"
                      :echo t)
             (format t "TRACE: sudo certbot --nginx -d ~A -d www.~A"
                     host host)
             (lake:sh (fmt "sudo certbot --nginx -d ~A -d www.~A"
                           host host)
                      :echo t)))
      (when host
        (list (install-config "nginx.conf"
                              (uiop:parse-unix-namestring
                               (fmt "/etc/nginx/sites-enabled/~A.conf"
                                    (add-dev-suffix-if-needed app-name)))

                              :partials '(("proxy" . "nginx-routes/proxy.conf"))
                              :check-func #'check-nginx-config
                              :on-update-func #'on-update
                              ;; Args for a template
                              :app-name app-name
                              :routes (loop for route in (webservice-routes component)
                                            collect (route-to-alist component route))
                              :host host
                              :ssl-certificate (namestring-if-exists
                                                (fmt "/etc/letsencrypt/live/~A/fullchain.pem"
                                                     host))
                              :ssl-certificate-key (namestring-if-exists
                                                    (fmt "/etc/letsencrypt/live/~A/privkey.pem"
                                                         host))))))))

(defclass route ()
  ((url-prefix :initarg :url-prefix
               :type string
               :initform (required-argument :url-prefix)
               :reader url-prefix)))


(defclass proxy (route)
  ((backend-port :initarg :port
                 :type (or positive-fixnum
                           env-val)
                 :initform (required-argument :port)
                 :reader backend-port)
   (backend-host :initarg :host
                 :type (or string
                           env-val)
                 :initform "localhost"
                 :reader backend-host)))


(defun proxy (url-prefix port &key (host "localhost"))
  (make-instance 'proxy
                 :url-prefix url-prefix
                 :host host
                 :port port))


(defclass static (route)
  ((root :initarg :root
         :type (or null
                   string
                   env-val)
         :initform nil
         :reader static-root)))


(defun static (url-prefix &key root)
  "If root is not given, it will be made of server's host name like this:

   ```
   location /static/ {
     root /var/www/html/{{ host }};
   }
   ```
"
  (make-instance 'static
                 :url-prefix url-prefix
                 :root root))


(defgeneric route-to-alist (component route)
  (:method ((component webservice) (route route))
    (list (cons "type"
                (string-downcase (serapeum:class-name-of route)))
          (cons "url-prefix"
                (resolve-env-value (url-prefix route)))))
  
  (:method ((component webservice) (route proxy))
    (append (list (cons "host" (resolve-env-value (backend-host route)))
                  (cons "port" (resolve-env-value (backend-port route))))
            (call-next-method)))
  
  (:method ((component webservice) (route static))
    (append (list (cons "root" (or (resolve-env-value (static-root route))
                                   (fmt "/var/www/html/~A"
                                        (webservice-host component)))))
            (call-next-method))))
