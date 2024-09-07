(uiop:define-package #:40ants-lake/commands/build
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:cl-ansi-text
                #:green)
  (:import-from #:40ants-lake/app
                #:*apps*
                #:app-name
                #:build-app)
  (:import-from #:40ants-lake/errors
                #:lake-error))
(in-package #:40ants-lake/commands/build)



(lake:task "build"
    ()
  "Build binaries for all apps."
  (cond
    (40ants-lake/app::*apps*
     (loop for app in *apps*
           do (format *error-output*
                      (green
                       (format nil "Building ~A app...~%"
                               (app-name app))))
              (build-app app)))
    (t
     (lake-error "Please, define at least one app using DEFAPPS macro in the Lakefile"))))


