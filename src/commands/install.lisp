(uiop:define-package #:40ants-lake/commands/install
  (:use #:cl)
  (:import-from #:lake))
(in-package #:40ants-lake/commands/install)


(lake:task "install" ()
  "Install service config files to run it under systemd."
  (lake:sh "echo Installing scripts and configs to run the service."))
