<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# 40ants-lake - Common Lake commands for 40Ants projects.

<a id="40-ants-lake-asdf-system-details"></a>

## 40ANTS-LAKE ASDF System Details

* Description: Common Lake commands for `40A`nts projects.
* Licence: Unlicense
* Author: Artemenko Alexander <svetlyak.40wt@gmail.com>
* Homepage: [https://40ants.com/40ants-lake/][5e55]
* Bug tracker: [https://github.com/40ants/40ants-lake/issues][43ae]
* Source control: [GIT][4665]
* Depends on: [alexandria][8236], [asdf][c15d], [cl-ansi-text][1499], [cl-mustache][1dd0], [lake][4339], [lparallel][e72d], [serapeum][c41d], [str][ef7f]

[![](https://github-actions.40ants.com/40ants/40ants-lake/matrix.svg?only=ci.run-tests)][822c]

![](http://quickdocs.org/badge/40ants-lake.svg)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :40ants-lake)
```
<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

`TODO`: Write a library description. Put some examples here.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/APP

<a id="x-28-23A-28-2815-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FAPP-22-29-20PACKAGE-29"></a>

#### [package](d87e) `40ants-lake/app`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-24APP-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### APP

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20CLASS-29"></a>

###### [class](c29c) `40ants-lake/app:app` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-BUILDER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](4ebe) `40ants-lake/app:app-builder` (app) (:builder = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-COMPONENTS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](1605) `40ants-lake/app:app-components` (app) (:components)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](442c) `40ants-lake/app:app-extra-revisions` (app) (:extra-revisions = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](5c41) `40ants-lake/app:app-health-check-url` (app) (:health-check-url = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-LISP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](34c2) `40ants-lake/app:app-lisp` (app) (:LISP = "sbcl-bin")

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-NAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](4105) `40ants-lake/app:app-name` (app) (:name)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](4b78) `40ants-lake/app:app-release-paths` (app) (:RELEASE-PATHS = '(("bin" . "bin/")))

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-REVISIONS-TO-KEEP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](b672) `40ants-lake/app:app-revisions-to-keep` (app) (:revisions-to-keep = 3)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-TARGET-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](7ecc) `40ants-lake/app:app-target-host` (app) (:target-host = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILD-APP-20GENERIC-FUNCTION-29"></a>

##### [generic-function](f241) `40ants-lake/app:build-app` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20FUNCTION-29"></a>

##### [function](7262) `40ants-lake/app:app` NAME &KEY COMPONENTS TARGET-HOST (REVISIONS-TO-KEEP 3) (RELEASE-PATHS '(("bin" . "bin/"))) EXTRA-REVISIONS (LISP "sbcl-bin") BUILDER HEALTH-CHECK-URL

<a id="x-2840ANTS-LAKE-2FAPP-3ABIN-READY-P-20FUNCTION-29"></a>

##### [function](72fd) `40ants-lake/app:bin-ready-p` &optional (root (uiop/os:getcwd))

Return T when `ROOT`/bin holds a build that can be released as-is.

The directory exists and contains at least one file that is not a
shared library. Deploy fills bin/ with the executable plus *.so
libraries, so a bin/ holding only libraries means the executable
artifact is missing and the build has to run. 'lake to-prod' uses this
to deploy the already built binary; 'lake build' keeps rebuilding
unconditionally.

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILDER-TRACT-P-20FUNCTION-29"></a>

##### [function](b153) `40ants-lake/app:builder-tract-p` app root

Return T when `APP` builds through the 40ants-builder library.

T is returned either when the app passes the `BUILDER` slot or, for
backward compatibility, when `ROOT` contains a build.lisp. Other apps
keep using the legacy roswell/<name>.ros build.

<a id="x-2840ANTS-LAKE-2FAPP-3ACURRENT-APP-20FUNCTION-29"></a>

##### [function](ebd6) `40ants-lake/app:current-app`

<a id="x-2840ANTS-LAKE-2FAPP-3ADELETE-STALE-ARTIFACT-20FUNCTION-29"></a>

##### [function](4c73) `40ants-lake/app:delete-stale-artifact` app

Delete the previous bin/<name> artifact, if any.

`ASDF` skips deploy-op when its output file is newer than the inputs, so
without this a build would silently keep the stale binary when nothing
tracked changed — for example right after switching the `LISP` slot from
one implementation to another.

<a id="x-2840ANTS-LAKE-2FAPP-3ALEGACY-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](c2e4) `40ants-lake/app:legacy-build-command` name

Return the legacy build command for projects without build.lisp.

<a id="x-2840ANTS-LAKE-2FAPP-3ARELEASE-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](30ec) `40ants-lake/app:release-build-command` app

Return the command building the release via the 40ants-builder library.

A fresh Roswell process runs in the project's Qlot environment: it
quickloads the builder and calls `(40ants-builder:build :<name>)`,
where the name is the app's name used as the `ASDF` system designator.
The builder registers the project's local systems, applies the `CCL`
and `ECL` workarounds, pins the build identification (the system's `ASDF`
version plus the git commit) and dumps the binary via Deploy. The
project's build.lisp, which marked this tract before, is not executed
anymore.

The Lisp is passed to Roswell with -L, taken from the `LISP` slot
("sbcl-bin" by default). Any spec accepted by `ros run -L` works,
for example "ccl-bin/1.13" or a pinned "sbcl-bin/2.5.9". When the
slot is `NIL`, no -L argument is given and Roswell picks its default
Lisp.

Roswell forwards everything after -- to the implementation's own
command line, and those flags are implementation specific:
`--non-interactive` exists on `SBCL`, while `CCL` rejects it with
"Unknown option" and gets only the eval forms. That is safe because
the builder quits the process explicitly both on success and failure.

<a id="x-2840ANTS-LAKE-2FAPP-3AUSES-BUILD-LISP-P-20FUNCTION-29"></a>

##### [function](b9ad) `40ants-lake/app:uses-build-lisp-p` root

Return T when `ROOT` contains a build.lisp.

The file was the marker of the Deploy tract back when lake executed
it directly. It is kept for backward compatibility: projects with
build.lisp still build through the 40ants-builder library, but the
file itself is not executed anymore.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FAPP-3ADEFAPPS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](5621) `40ants-lake/app:defapps` &body apps

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMMANDS/TO-PROD

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMMANDS-2FTO-PROD-22-29-20PACKAGE-29"></a>

#### [package](f883) `40ants-lake/commands/to-prod`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3ADEPLOY-APP-20FUNCTION-29"></a>

##### [function](0b2f) `40ants-lake/commands/to-prod:deploy-app` app

Deploy a single `APP` and return the deploy mode used.

Apps of the Deploy tract (marked by a build.lisp in the project root,
built via the 40ants-builder library) are installed as /srv/services
releases via the install-release helper; apps without it fall back to
the legacy roswell binary copying. Remote targets are not supported yet.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AHEALTH-CHECK-COMMANDS-20FUNCTION-29"></a>

##### [function](6018) `40ants-lake/commands/to-prod:health-check-commands` app

Return shell commands verifying that the service of `APP` is alive.

Always includes `systemctl is-active`; when [`app-health-check-url`][529f] is set,
also a curl returning the `HTTP` code (000 means nothing is listening).

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-COMMAND-20FUNCTION-29"></a>

##### [function](86a2) `40ants-lake/commands/to-prod:install-release-command` name staging keep

Return the command installing `STAGING` as a new release of the service `NAME`.

The helper is the single write entry point into /srv/services: it copies
the revision, runs the smoke test as the service user, atomically flips
`current`, restarts the service and prunes old revisions down to `KEEP`.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-SCRIPT-PATH-20FUNCTION-29"></a>

##### [function](72c9) `40ants-lake/commands/to-prod:install-release-script-path`

Return the absolute path of the install-release helper shipped in the 40ants-lake checkout.

The helper lives next to the lake sources and is always in sync with the
running code; no host-wide copy in /usr/local/sbin is required.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/DAEMON

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FDAEMON-22-29-20PACKAGE-29"></a>

#### [package](d265) `40ants-lake/component/daemon`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-24DAEMON-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### DAEMON

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20CLASS-29"></a>

###### [class](5f7f) `40ants-lake/component/daemon:daemon` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](8dc4) `40ants-lake/component/daemon:daemon-environment` (daemon) (:environment = nil)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](980b) `40ants-lake/component/daemon:daemon-user` (daemon) (:USER = "root")

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20FUNCTION-29"></a>

##### [function](97d1) `40ants-lake/component/daemon:daemon` &KEY ENVIRONMENT (USER (OR (UIOP/OS:GETENV "USER") "root"))

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3AHAS-DAEMON-COMPONENT-P-20FUNCTION-29"></a>

##### [function](61a2) `40ants-lake/component/daemon:has-daemon-component-p` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/WEBSERVICE

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-22-29-20PACKAGE-29"></a>

#### [package](72f2) `40ants-lake/component/webservice`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24PROXY-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PROXY

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20CLASS-29"></a>

###### [class](c459) `40ants-lake/component/webservice:proxy` (route)

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](192e) `40ants-lake/component/webservice:backend-host` (proxy) (:HOST = "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-PORT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](29a0) `40ants-lake/component/webservice:backend-port` (proxy) (:port = (required-argument :port))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24ROUTE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ROUTE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-20CLASS-29"></a>

###### [class](7183) `40ants-lake/component/webservice:route` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AURL-PREFIX-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-29-29"></a>

###### [reader](f117) `40ants-lake/component/webservice:url-prefix` (route) (:url-prefix = (required-argument :url-prefix))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24WEBSERVICE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### WEBSERVICE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20CLASS-29"></a>

###### [class](66b2) `40ants-lake/component/webservice:webservice` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](d9f6) `40ants-lake/component/webservice:webservice-host` (webservice) (:host)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-ROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](d960) `40ants-lake/component/webservice:webservice-routes` (webservice) (:routes)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20FUNCTION-29"></a>

##### [function](a7e2) `40ants-lake/component/webservice:proxy` URL-PREFIX PORT &KEY (HOST "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20FUNCTION-29"></a>

##### [function](f730) `40ants-lake/component/webservice:webservice` host &key routes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/CONFIGS/INSTALL-CONFIG

<a id="x-28-23A-28-2834-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-22-29-20PACKAGE-29"></a>

#### [package](e439) `40ants-lake/configs/install-config`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-24INSTALL-CONFIG-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### INSTALL-CONFIG

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20CLASS-29"></a>

###### [class](5893) `40ants-lake/configs/install-config:install-config` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHECK-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](e6b8) `40ants-lake/configs/install-config:check-func` (install-config) (:check-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHMOD-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](60a0) `40ants-lake/configs/install-config:chmod-to` (install-config) (:chmod = \*default-chmod\*)

A mask like 600 to chmod file after creation. If not given, it will be 600

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHOWN-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](523f) `40ants-lake/configs/install-config:chown-to` (install-config) (:chown)

A user:group to chown file to. If not given, then it will belong current user.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AON-UPDATE-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](6c11) `40ants-lake/configs/install-config:on-update-func` (install-config) (:on-update-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATARGET-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](e41d) `40ants-lake/configs/install-config:target-filename` (install-config) (:target-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](890a) `40ants-lake/configs/install-config:template-filename` (install-config) (:template-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-PARTIALS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](59c4) `40ants-lake/configs/install-config:template-partials` (install-config) (:partials)

Alist of where key is a string name of the partial and value is a template filename.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-VARS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](9801) `40ants-lake/configs/install-config:template-vars` (install-config) (:template-vars)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20FUNCTION-29"></a>

##### [function](2ea8) `40ants-lake/configs/install-config:install-config` template-name target-filename &rest template-vars &key check-func on-update-func partials (chmod \*default-chmod\*) chown &allow-other-keys

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENV-VAL

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENV-VAL-22-29-20PACKAGE-29"></a>

#### [package](d08e) `40ants-lake/env-val`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-24ENV-VAL-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ENV-VAL

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20CLASS-29"></a>

###### [class](747b) `40ants-lake/env-val:env-val` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ADEV-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](88e8) `40ants-lake/env-val:dev-value` (env-val) (:dev = nil)

<a id="x-2840ANTS-LAKE-2FENV-VAL-3APROD-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](eebd) `40ants-lake/env-val:prod-value` (env-val) (:prod = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20FUNCTION-29"></a>

##### [function](8b30) `40ants-lake/env-val:env-val` &key prod dev

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ARESOLVE-ENV-VALUE-20FUNCTION-29"></a>

##### [function](12dc) `40ants-lake/env-val:resolve-env-value` value &key (env \*current-environment\*)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENVIRONMENT-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENVIRONMENT

<a id="x-28-23A-28-2823-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENVIRONMENT-22-29-20PACKAGE-29"></a>

#### [package](8613) `40ants-lake/environment`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-DEV-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](fd31) `40ants-lake/environment:add-dev-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-PROD-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](4afd) `40ants-lake/environment:add-prod-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AASSERT-VALID-ENVIRONMENT-20FUNCTION-29"></a>

##### [function](b1e2) `40ants-lake/environment:assert-valid-environment` env

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3ALOAD-ENV-FILE-20FUNCTION-29"></a>

##### [function](1728) `40ants-lake/environment:load-env-file`

Loads .env file with lines like:

```
TOKEN=foo
PORT=100500
```
<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AWITH-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](ebb6) `40ants-lake/environment:with-environment` (environment) &body body

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ERRORS

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](0752) `40ants-lake/errors`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-24LAKE-ERROR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LAKE-ERROR

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20CONDITION-29"></a>

###### [condition](6ef8) `40ants-lake/errors:lake-error` (error)

**Readers**

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FERRORS-3ALAKE-ERROR-29-29"></a>

###### [reader](6ef8) `40ants-lake/errors:lake-error-message` (lake-error) (:message)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20FUNCTION-29"></a>

##### [function](7e73) `40ants-lake/errors:lake-error` message &rest args

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FINSTALLATION-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/INSTALLATION

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FINSTALLATION-22-29-20PACKAGE-29"></a>

#### [package](ba42) `40ants-lake/installation`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FINSTALLATION-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FINSTALLATION-3ACOLLECT-INSTALLATION-STEPS-20GENERIC-FUNCTION-29"></a>

##### [generic-function](cd49) `40ants-lake/installation:collect-installation-steps` app-or-component

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FPERFORM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/PERFORM

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FPERFORM-22-29-20PACKAGE-29"></a>

#### [package](216f) `40ants-lake/perform`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FPERFORM-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FPERFORM-3APERFORM-20GENERIC-FUNCTION-29"></a>

##### [generic-function](28b0) `40ants-lake/perform:perform` step

Performs an installation step.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FRELEASE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/RELEASE

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FRELEASE-22-29-20PACKAGE-29"></a>

#### [package](98ba) `40ants-lake/release`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FRELEASE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FRELEASE-3AMAKE-STAGING-20FUNCTION-29"></a>

##### [function](06e3) `40ants-lake/release:make-staging` app root

Assemble a temporary staging directory for a release of `APP`.

The staging directory is created atomically and is unique across processes;
concurrent deployments cannot collide or reuse a failed attempt's directory.

Each element of [`app-release-paths`][7752] is a (staging-path . source-path) pair:
directories are copied recursively, files create their parent directories.
`REVISION` receives `git rev-parse HEAD` of `ROOT`; each element of
[`app-extra-revisions`][f059], a (filename . git-path) pair, receives `git rev-parse
HEAD` of the nested repository at `ROOT`/git-path.

The caller is responsible for removing the returned directory after the
release has been installed.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FUTILS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/UTILS

<a id="x-28-23A-28-2817-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FUTILS-22-29-20PACKAGE-29"></a>

#### [package](2f92) `40ants-lake/utils`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FUTILS-3AALIAS-20FUNCTION-29"></a>

##### [function](5767) `40ants-lake/utils:alias` alias-name existing-task-name

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-FULL-PATH-20FUNCTION-29"></a>

##### [function](6abf) `40ants-lake/utils:get-full-path` path

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `deploy/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-SYSTEM-PATH-20FUNCTION-29"></a>

##### [function](801f) `40ants-lake/utils:get-system-path` PATH &KEY (PREFIX "deploy/")

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `/home/username/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3ANAMESTRING-IF-EXISTS-20FUNCTION-29"></a>

##### [function](8b54) `40ants-lake/utils:namestring-if-exists` path-or-string


[5e55]: https://40ants.com/40ants-lake/
[f059]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[529f]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[7752]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[4665]: https://github.com/40ants/40ants-lake
[822c]: https://github.com/40ants/40ants-lake/actions
[d87e]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L1
[b9ad]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L137
[b153]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L149
[c2e4]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L160
[4c73]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L166
[72fd]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L192
[f241]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L208
[5621]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L217
[ebd6]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L222
[c29c]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L39
[4105]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L40
[1605]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L43
[7ecc]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L46
[b672]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L50
[4b78]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L54
[442c]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L58
[34c2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L62
[4ebe]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L66
[5c41]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L70
[7262]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L76
[30ec]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/app.lisp#L98
[f883]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/commands/to-prod.lisp#L1
[0b2f]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/commands/to-prod.lisp#L134
[72c9]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/commands/to-prod.lisp#L41
[86a2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/commands/to-prod.lisp#L54
[6018]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/commands/to-prod.lisp#L68
[d265]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L1
[5f7f]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L32
[8dc4]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L33
[980b]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L37
[97d1]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L43
[61a2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/daemon.lisp#L94
[72f2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L1
[7183]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L112
[f117]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L113
[c459]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L119
[29a0]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L120
[192e]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L125
[a7e2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L132
[66b2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L34
[d9f6]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L35
[d960]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L38
[f730]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/component/webservice.lisp#L43
[e439]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L1
[5893]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L33
[890a]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L34
[e41d]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L37
[9801]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L40
[59c4]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L43
[523f]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L47
[60a0]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L51
[e6b8]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L56
[6c11]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L60
[2ea8]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/configs/install-config.lisp#L93
[d08e]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L1
[747b]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L13
[eebd]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L14
[88e8]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L17
[8b30]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L22
[12dc]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/env-val.lisp#L35
[8613]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L1
[b1e2]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L23
[ebb6]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L29
[fd31]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L36
[4afd]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L47
[1728]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/environment.lisp#L59
[0752]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/errors.lisp#L1
[6ef8]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/errors.lisp#L10
[7e73]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/errors.lisp#L18
[ba42]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/installation.lisp#L1
[cd49]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/installation.lisp#L7
[216f]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/perform.lisp#L1
[28b0]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/perform.lisp#L7
[98ba]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/release.lisp#L1
[06e3]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/release.lisp#L73
[2f92]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/utils.lisp#L1
[5767]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/utils.lisp#L16
[6abf]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/utils.lisp#L38
[801f]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/utils.lisp#L50
[8b54]: https://github.com/40ants/40ants-lake/blob/c23e06f3c83992f14ca289e73d123abad1848283/src/utils.lisp#L74
[43ae]: https://github.com/40ants/40ants-lake/issues
[8236]: https://quickdocs.org/alexandria
[c15d]: https://quickdocs.org/asdf
[1499]: https://quickdocs.org/cl-ansi-text
[1dd0]: https://quickdocs.org/cl-mustache
[4339]: https://quickdocs.org/lake
[e72d]: https://quickdocs.org/lparallel
[c41d]: https://quickdocs.org/serapeum
[ef7f]: https://quickdocs.org/str

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
