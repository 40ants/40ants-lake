(uiop:define-package #:40ants-lake/commands/install
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/utils
                #:get-system-path
                #:get-full-path)
  (:import-from #:40ants-lake/app
                #:app-name
                #:app-components
                #:*apps*)
  (:import-from #:cl-ansi-text
                #:yellow
                #:green)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:40ants-lake/perform
                #:perform)
  (:import-from #:40ants-lake/environment
                #:with-environment))
(in-package #:40ants-lake/commands/install)





(lake:task "install" ()
  "Installs configs and other files needed to run apps under systemd and nginx."
  (loop for app in *apps*
        for install-steps = (append (with-environment (:dev)
                                      (collect-installation-steps app))
                                    (with-environment (:prod)
                                      (collect-installation-steps app)))
        when install-steps
        do (write-string (green (format nil "Installing app ~S...~%"
                                        (app-name app)))
                         *error-output*)
           (loop for step in install-steps
                 do (perform step))))
