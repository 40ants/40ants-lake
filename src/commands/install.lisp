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
                #:perform))
(in-package #:40ants-lake/commands/install)





(lake:task "install" ()
  "Installs configs and other files needed to run apps under systemd and nginx."
  ;; (format t "APPS: ~S"
  ;;         *apps*)
  (loop for app in *apps*
        for install-steps = (collect-installation-steps app)
        when install-steps
        do (write-string (green (format nil "Installing app ~S...~%"
                                        (app-name app)))
                         *error-output*)
           (loop for step in install-steps
                 do (perform step)))
  
  ;; (loop with symlinks = '(;; "deploy/etc/systemd/system/chit-chat-frontend-dev.service" 
  ;;                         ;; systemctl --user enable chit-chat-passport-backend
  ;;                         "deploy/$HOME/.local/share/systemd/user/chit-chat-passport-backend.service"
  ;;                         "deploy/$HOME/.local/share/systemd/user/chit-chat-chat-backend.service"
  ;;                         "deploy/$HOME/.local/share/systemd/user/chit-chat-frontend.service"
  ;;                         "deploy/etc/nginx/sites-enabled/dev.kinojaba.ru")
  ;;       for source in symlinks
  ;;       for full-source-path = (get-full-path source)
  ;;       for system-path = (get-system-path source)
  ;;       unless (uiop:file-exists-p system-path)
  ;;       do (lake:sh (format nil
  ;;                           "sudo ln -s -f ~A ~A"
  ;;                           full-source-path
  ;;                           system-path)))

  ;; (lake:sh "sudo systemctl daemon-reload")
  )
