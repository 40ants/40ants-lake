(uiop:define-package #:40ants-lake/commands/to-prod
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
  (:import-from #:40ants-lake/perform
                #:perform)
  (:import-from #:40ants-lake/environment
                #:add-prod-suffix-if-needed
                #:with-environment))
(in-package #:40ants-lake/commands/to-prod)


(lake:task "to-prod" ()
  "Moves a binary from dev to prod and then restarts the apps in prod environment."
  (loop for app in *apps*
        for app-name = (app-name app)
        for dev-binary-name = app-name
        for prod-binary-name = (with-environment (:prod)
                                 (add-prod-suffix-if-needed app-name))
        for dev-binary-path = (make-pathname :directory '(:relative "roswell")
                                             :name dev-binary-name)
        for prod-binary-path = (make-pathname :directory '(:relative "roswell")
                                              :name prod-binary-name)
        when (probe-file dev-binary-path)
        do (when (probe-file prod-binary-path)
             ;; TODO: make it keep N latest versions
             (lake:sh (list "rm"
                            (namestring prod-binary-path))))
           (lake:sh (list "cp"
                          "--preserve=all"
                          (namestring dev-binary-path)
                          (namestring prod-binary-path))))

  (lake:lake :target "restart[prod]"))
