(uiop:define-package #:40ants-lake/perform
  (:use #:cl)
  (:export #:perform))
(in-package #:40ants-lake/perform)


(defgeneric perform (step)
  (:documentation "Performs an installation step."))
