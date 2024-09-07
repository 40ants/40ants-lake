(uiop:define-package #:40ants-lake/installation
  (:use #:cl)
  (:export #:collect-installation-steps))
(in-package #:40ants-lake/installation)


(defgeneric collect-installation-steps (app-or-component)
  ;; (:documentation "Should return a number of step objects for which PERFORM generic-function could be called.")
  )
