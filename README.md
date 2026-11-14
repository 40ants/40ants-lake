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

#### [package](e9d8) `40ants-lake/app`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-24APP-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### APP

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20CLASS-29"></a>

###### [class](c0ea) `40ants-lake/app:app` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-COMPONENTS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](540b) `40ants-lake/app:app-components` (app) (:components)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](ec3a) `40ants-lake/app:app-extra-revisions` (app) (:extra-revisions = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](65a9) `40ants-lake/app:app-health-check-url` (app) (:health-check-url = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-LISP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](f476) `40ants-lake/app:app-lisp` (app) (:LISP = "sbcl-bin")

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-NAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](81d8) `40ants-lake/app:app-name` (app) (:name)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](8328) `40ants-lake/app:app-release-paths` (app) (:RELEASE-PATHS = '(("bin" . "bin/")))

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-REVISIONS-TO-KEEP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](354e) `40ants-lake/app:app-revisions-to-keep` (app) (:revisions-to-keep = 3)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-TARGET-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](6861) `40ants-lake/app:app-target-host` (app) (:target-host = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILD-APP-20GENERIC-FUNCTION-29"></a>

##### [generic-function](c267) `40ants-lake/app:build-app` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20FUNCTION-29"></a>

##### [function](54bd) `40ants-lake/app:app` NAME &KEY COMPONENTS TARGET-HOST (REVISIONS-TO-KEEP 3) (RELEASE-PATHS '(("bin" . "bin/"))) EXTRA-REVISIONS (LISP "sbcl-bin") HEALTH-CHECK-URL

<a id="x-2840ANTS-LAKE-2FAPP-3ABIN-READY-P-20FUNCTION-29"></a>

##### [function](5741) `40ants-lake/app:bin-ready-p` &optional (root (uiop/os:getcwd))

Return T when `ROOT`/bin holds a build that can be released as-is.

The directory exists and contains at least one file that is not a
shared library. Deploy fills bin/ with the executable plus *.so
libraries, so a bin/ holding only libraries means the executable
artifact is missing and the build has to run. 'lake to-prod' uses this
to deploy the already built binary; 'lake build' keeps rebuilding
unconditionally.

<a id="x-2840ANTS-LAKE-2FAPP-3ACURRENT-APP-20FUNCTION-29"></a>

##### [function](51b1) `40ants-lake/app:current-app`

<a id="x-2840ANTS-LAKE-2FAPP-3ADELETE-STALE-ARTIFACT-20FUNCTION-29"></a>

##### [function](12ab) `40ants-lake/app:delete-stale-artifact` app

Delete the previous bin/<name> artifact, if any.

`ASDF` skips deploy-op when its output file is newer than the inputs, so
without this a build would silently keep the stale binary when nothing
tracked changed — for example right after switching the `LISP` slot from
one implementation to another.

<a id="x-2840ANTS-LAKE-2FAPP-3ALEGACY-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](0d23) `40ants-lake/app:legacy-build-command` name

Return the legacy build command for projects without build.lisp.

<a id="x-2840ANTS-LAKE-2FAPP-3ARELEASE-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](b0ee) `40ants-lake/app:release-build-command` app

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

##### [function](b77b) `40ants-lake/app:uses-build-lisp-p` root

Return T when `ROOT` contains a build.lisp.

The file marks the project as using the Deploy tract: such projects
are built through the 40ants-builder library by lake build and
installed as /srv/services releases by lake to-prod. The file itself
is not executed anymore; it only serves as the tract marker, kept for
backward compatibility.

Projects without build.lisp keep using the legacy roswell/<name>.ros build.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FAPP-3ADEFAPPS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](c925) `40ants-lake/app:defapps` &body apps

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMMANDS/TO-PROD

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMMANDS-2FTO-PROD-22-29-20PACKAGE-29"></a>

#### [package](db61) `40ants-lake/commands/to-prod`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3ADEPLOY-APP-20FUNCTION-29"></a>

##### [function](d659) `40ants-lake/commands/to-prod:deploy-app` app

Deploy a single `APP` and return the deploy mode used.

Apps of the Deploy tract (marked by a build.lisp in the project root,
built via the 40ants-builder library) are installed as /srv/services
releases via the install-release helper; apps without it fall back to
the legacy roswell binary copying. Remote targets are not supported yet.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AHEALTH-CHECK-COMMANDS-20FUNCTION-29"></a>

##### [function](35f1) `40ants-lake/commands/to-prod:health-check-commands` app

Return shell commands verifying that the service of `APP` is alive.

Always includes `systemctl is-active`; when [`app-health-check-url`][529f] is set,
also a curl returning the `HTTP` code (000 means nothing is listening).

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-COMMAND-20FUNCTION-29"></a>

##### [function](fc65) `40ants-lake/commands/to-prod:install-release-command` name staging keep

Return the command installing `STAGING` as a new release of the service `NAME`.

The helper is the single write entry point into /srv/services: it copies
the revision, runs the smoke test as the service user, atomically flips
`current`, restarts the service and prunes old revisions down to `KEEP`.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-SCRIPT-PATH-20FUNCTION-29"></a>

##### [function](ebd0) `40ants-lake/commands/to-prod:install-release-script-path`

Return the absolute path of the install-release helper shipped in the 40ants-lake checkout.

The helper lives next to the lake sources and is always in sync with the
running code; no host-wide copy in /usr/local/sbin is required.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/DAEMON

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FDAEMON-22-29-20PACKAGE-29"></a>

#### [package](b596) `40ants-lake/component/daemon`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-24DAEMON-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### DAEMON

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20CLASS-29"></a>

###### [class](6a70) `40ants-lake/component/daemon:daemon` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](0fff) `40ants-lake/component/daemon:daemon-environment` (daemon) (:environment = nil)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](7ed9) `40ants-lake/component/daemon:daemon-user` (daemon) (:USER = "root")

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20FUNCTION-29"></a>

##### [function](c795) `40ants-lake/component/daemon:daemon` &KEY ENVIRONMENT (USER (OR (UIOP/OS:GETENV "USER") "root"))

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3AHAS-DAEMON-COMPONENT-P-20FUNCTION-29"></a>

##### [function](77a7) `40ants-lake/component/daemon:has-daemon-component-p` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/WEBSERVICE

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-22-29-20PACKAGE-29"></a>

#### [package](f447) `40ants-lake/component/webservice`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24PROXY-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PROXY

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20CLASS-29"></a>

###### [class](9cda) `40ants-lake/component/webservice:proxy` (route)

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](75ce) `40ants-lake/component/webservice:backend-host` (proxy) (:HOST = "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-PORT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](5ca5) `40ants-lake/component/webservice:backend-port` (proxy) (:port = (required-argument :port))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24ROUTE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ROUTE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-20CLASS-29"></a>

###### [class](3e13) `40ants-lake/component/webservice:route` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AURL-PREFIX-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-29-29"></a>

###### [reader](84c3) `40ants-lake/component/webservice:url-prefix` (route) (:url-prefix = (required-argument :url-prefix))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24WEBSERVICE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### WEBSERVICE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20CLASS-29"></a>

###### [class](c076) `40ants-lake/component/webservice:webservice` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](5103) `40ants-lake/component/webservice:webservice-host` (webservice) (:host)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-ROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](917b) `40ants-lake/component/webservice:webservice-routes` (webservice) (:routes)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20FUNCTION-29"></a>

##### [function](0ddd) `40ants-lake/component/webservice:proxy` URL-PREFIX PORT &KEY (HOST "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20FUNCTION-29"></a>

##### [function](5358) `40ants-lake/component/webservice:webservice` host &key routes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/CONFIGS/INSTALL-CONFIG

<a id="x-28-23A-28-2834-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-22-29-20PACKAGE-29"></a>

#### [package](4f6d) `40ants-lake/configs/install-config`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-24INSTALL-CONFIG-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### INSTALL-CONFIG

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20CLASS-29"></a>

###### [class](9c9b) `40ants-lake/configs/install-config:install-config` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHECK-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](a31b) `40ants-lake/configs/install-config:check-func` (install-config) (:check-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHMOD-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](cbb1) `40ants-lake/configs/install-config:chmod-to` (install-config) (:chmod = \*default-chmod\*)

A mask like 600 to chmod file after creation. If not given, it will be 600

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHOWN-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](815e) `40ants-lake/configs/install-config:chown-to` (install-config) (:chown)

A user:group to chown file to. If not given, then it will belong current user.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AON-UPDATE-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](c358) `40ants-lake/configs/install-config:on-update-func` (install-config) (:on-update-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATARGET-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](8988) `40ants-lake/configs/install-config:target-filename` (install-config) (:target-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](a89c) `40ants-lake/configs/install-config:template-filename` (install-config) (:template-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-PARTIALS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](2e5c) `40ants-lake/configs/install-config:template-partials` (install-config) (:partials)

Alist of where key is a string name of the partial and value is a template filename.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-VARS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](4e7e) `40ants-lake/configs/install-config:template-vars` (install-config) (:template-vars)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20FUNCTION-29"></a>

##### [function](bed0) `40ants-lake/configs/install-config:install-config` template-name target-filename &rest template-vars &key check-func on-update-func partials (chmod \*default-chmod\*) chown &allow-other-keys

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENV-VAL

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENV-VAL-22-29-20PACKAGE-29"></a>

#### [package](18b6) `40ants-lake/env-val`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-24ENV-VAL-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ENV-VAL

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20CLASS-29"></a>

###### [class](645b) `40ants-lake/env-val:env-val` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ADEV-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](bb4e) `40ants-lake/env-val:dev-value` (env-val) (:dev = nil)

<a id="x-2840ANTS-LAKE-2FENV-VAL-3APROD-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](8585) `40ants-lake/env-val:prod-value` (env-val) (:prod = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20FUNCTION-29"></a>

##### [function](5b6f) `40ants-lake/env-val:env-val` &key prod dev

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ARESOLVE-ENV-VALUE-20FUNCTION-29"></a>

##### [function](a116) `40ants-lake/env-val:resolve-env-value` value &key (env \*current-environment\*)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENVIRONMENT-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENVIRONMENT

<a id="x-28-23A-28-2823-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENVIRONMENT-22-29-20PACKAGE-29"></a>

#### [package](3483) `40ants-lake/environment`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-DEV-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](b9fc) `40ants-lake/environment:add-dev-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-PROD-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](4d47) `40ants-lake/environment:add-prod-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AASSERT-VALID-ENVIRONMENT-20FUNCTION-29"></a>

##### [function](b0ef) `40ants-lake/environment:assert-valid-environment` env

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3ALOAD-ENV-FILE-20FUNCTION-29"></a>

##### [function](7587) `40ants-lake/environment:load-env-file`

Loads .env file with lines like:

```
TOKEN=foo
PORT=100500
```
<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AWITH-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](cfb7) `40ants-lake/environment:with-environment` (environment) &body body

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ERRORS

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](6320) `40ants-lake/errors`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-24LAKE-ERROR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LAKE-ERROR

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20CONDITION-29"></a>

###### [condition](ea44) `40ants-lake/errors:lake-error` (error)

**Readers**

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FERRORS-3ALAKE-ERROR-29-29"></a>

###### [reader](ea44) `40ants-lake/errors:lake-error-message` (lake-error) (:message)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20FUNCTION-29"></a>

##### [function](adec) `40ants-lake/errors:lake-error` message &rest args

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FINSTALLATION-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/INSTALLATION

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FINSTALLATION-22-29-20PACKAGE-29"></a>

#### [package](2125) `40ants-lake/installation`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FINSTALLATION-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FINSTALLATION-3ACOLLECT-INSTALLATION-STEPS-20GENERIC-FUNCTION-29"></a>

##### [generic-function](6ba8) `40ants-lake/installation:collect-installation-steps` app-or-component

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FPERFORM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/PERFORM

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FPERFORM-22-29-20PACKAGE-29"></a>

#### [package](5c74) `40ants-lake/perform`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FPERFORM-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FPERFORM-3APERFORM-20GENERIC-FUNCTION-29"></a>

##### [generic-function](134c) `40ants-lake/perform:perform` step

Performs an installation step.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FRELEASE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/RELEASE

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FRELEASE-22-29-20PACKAGE-29"></a>

#### [package](124d) `40ants-lake/release`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FRELEASE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FRELEASE-3AMAKE-STAGING-20FUNCTION-29"></a>

##### [function](1fe8) `40ants-lake/release:make-staging` app root

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

#### [package](4193) `40ants-lake/utils`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FUTILS-3AALIAS-20FUNCTION-29"></a>

##### [function](428a) `40ants-lake/utils:alias` alias-name existing-task-name

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-FULL-PATH-20FUNCTION-29"></a>

##### [function](cc6f) `40ants-lake/utils:get-full-path` path

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `deploy/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-SYSTEM-PATH-20FUNCTION-29"></a>

##### [function](02bc) `40ants-lake/utils:get-system-path` PATH &KEY (PREFIX "deploy/")

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `/home/username/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3ANAMESTRING-IF-EXISTS-20FUNCTION-29"></a>

##### [function](b83c) `40ants-lake/utils:namestring-if-exists` path-or-string


[5e55]: https://40ants.com/40ants-lake/
[f059]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[529f]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[7752]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[4665]: https://github.com/40ants/40ants-lake
[822c]: https://github.com/40ants/40ants-lake/actions
[e9d8]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L1
[b77b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L129
[0d23]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L144
[12ab]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L150
[5741]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L176
[c267]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L192
[c925]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L201
[51b1]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L206
[c0ea]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L37
[81d8]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L38
[540b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L41
[6861]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L44
[354e]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L48
[8328]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L52
[ec3a]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L56
[f476]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L60
[65a9]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L64
[54bd]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L70
[b0ee]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/app.lisp#L90
[db61]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/commands/to-prod.lisp#L1
[d659]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/commands/to-prod.lisp#L133
[ebd0]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/commands/to-prod.lisp#L40
[fc65]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/commands/to-prod.lisp#L53
[35f1]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/commands/to-prod.lisp#L67
[b596]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L1
[6a70]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L32
[0fff]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L33
[7ed9]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L37
[c795]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L43
[77a7]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/daemon.lisp#L94
[f447]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L1
[3e13]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L112
[84c3]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L113
[9cda]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L119
[5ca5]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L120
[75ce]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L125
[0ddd]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L132
[c076]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L34
[5103]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L35
[917b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L38
[5358]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/component/webservice.lisp#L43
[4f6d]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L1
[9c9b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L33
[a89c]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L34
[8988]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L37
[4e7e]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L40
[2e5c]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L43
[815e]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L47
[cbb1]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L51
[a31b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L56
[c358]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L60
[bed0]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/configs/install-config.lisp#L93
[18b6]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L1
[645b]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L13
[8585]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L14
[bb4e]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L17
[5b6f]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L22
[a116]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/env-val.lisp#L35
[3483]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L1
[b0ef]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L23
[cfb7]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L29
[b9fc]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L36
[4d47]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L47
[7587]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/environment.lisp#L59
[6320]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/errors.lisp#L1
[ea44]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/errors.lisp#L10
[adec]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/errors.lisp#L18
[2125]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/installation.lisp#L1
[6ba8]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/installation.lisp#L7
[5c74]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/perform.lisp#L1
[134c]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/perform.lisp#L7
[124d]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/release.lisp#L1
[1fe8]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/release.lisp#L73
[4193]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/utils.lisp#L1
[428a]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/utils.lisp#L16
[cc6f]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/utils.lisp#L38
[02bc]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/utils.lisp#L50
[b83c]: https://github.com/40ants/40ants-lake/blob/226d12c992ccad961387793bed48b31ac2156bae/src/utils.lisp#L74
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
