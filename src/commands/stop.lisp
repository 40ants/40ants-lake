(uiop:define-package #:40ants-lake/commands/stop
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/app
                #:*apps*
                #:app-name)
  (:import-from #:40ants-lake/environment
                #:add-dev-suffix-if-needed
                #:with-environment)
  (:import-from #:alexandria
                #:make-keyword)
  (:import-from #:40ants-lake/component/daemon
                #:has-daemon-component-p))
(in-package #:40ants-lake/commands/stop)


(lake:task ("stop" (env "dev")) ()
  "Stops all daemon apps in a given environment (by default it is dev)."
  
  (with-environment ((make-keyword (string-upcase env)))
    (loop for app in *apps*
          for app-name = (app-name app)
          for service-name = (add-dev-suffix-if-needed app-name)
          when (has-daemon-component-p app)
          do (lake:sh (list "sudo"
                            "systemctl"
                            "stop"
                            service-name)))))
