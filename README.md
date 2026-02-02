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
* Depends on: [alexandria][8236], [cl-ansi-text][1499], [cl-mustache][1dd0], [lake][4339], [lparallel][e72d], [serapeum][c41d], [str][ef7f]

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

#### [package](a077) `40ants-lake/app`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-24APP-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### APP

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20CLASS-29"></a>

###### [class](5df0) `40ants-lake/app:app` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-COMPONENTS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](31a7) `40ants-lake/app:app-components` (app) (:components)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-NAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](575d) `40ants-lake/app:app-name` (app) (:name)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILD-APP-20GENERIC-FUNCTION-29"></a>

##### [generic-function](c686) `40ants-lake/app:build-app` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20FUNCTION-29"></a>

##### [function](d9a0) `40ants-lake/app:app` name &key components

<a id="x-2840ANTS-LAKE-2FAPP-3ACURRENT-APP-20FUNCTION-29"></a>

##### [function](fbec) `40ants-lake/app:current-app`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FAPP-3ADEFAPPS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](b157) `40ants-lake/app:defapps` &body apps

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/DAEMON

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FDAEMON-22-29-20PACKAGE-29"></a>

#### [package](4317) `40ants-lake/component/daemon`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-24DAEMON-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### DAEMON

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20CLASS-29"></a>

###### [class](311f) `40ants-lake/component/daemon:daemon` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](589d) `40ants-lake/component/daemon:daemon-environment` (daemon) (:environment = nil)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](e109) `40ants-lake/component/daemon:daemon-user` (daemon) (:USER = "root")

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20FUNCTION-29"></a>

##### [function](b5ad) `40ants-lake/component/daemon:daemon` &KEY ENVIRONMENT (USER (OR (UIOP/OS:GETENV "USER") "root"))

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3AHAS-DAEMON-COMPONENT-P-20FUNCTION-29"></a>

##### [function](690d) `40ants-lake/component/daemon:has-daemon-component-p` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/WEBSERVICE

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-22-29-20PACKAGE-29"></a>

#### [package](c607) `40ants-lake/component/webservice`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24PROXY-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PROXY

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20CLASS-29"></a>

###### [class](a1cb) `40ants-lake/component/webservice:proxy` (route)

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](f5f4) `40ants-lake/component/webservice:backend-host` (proxy) (:HOST = "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-PORT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](9b54) `40ants-lake/component/webservice:backend-port` (proxy) (:port = (required-argument :port))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24ROUTE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ROUTE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-20CLASS-29"></a>

###### [class](c603) `40ants-lake/component/webservice:route` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AURL-PREFIX-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-29-29"></a>

###### [reader](d0d6) `40ants-lake/component/webservice:url-prefix` (route) (:url-prefix = (required-argument :url-prefix))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24WEBSERVICE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### WEBSERVICE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20CLASS-29"></a>

###### [class](98e5) `40ants-lake/component/webservice:webservice` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](a89b) `40ants-lake/component/webservice:webservice-host` (webservice) (:host)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-ROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](aac4) `40ants-lake/component/webservice:webservice-routes` (webservice) (:routes)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20FUNCTION-29"></a>

##### [function](782d) `40ants-lake/component/webservice:proxy` URL-PREFIX PORT &KEY (HOST "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20FUNCTION-29"></a>

##### [function](eb73) `40ants-lake/component/webservice:webservice` host &key routes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/CONFIGS/INSTALL-CONFIG

<a id="x-28-23A-28-2834-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-22-29-20PACKAGE-29"></a>

#### [package](01da) `40ants-lake/configs/install-config`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-24INSTALL-CONFIG-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### INSTALL-CONFIG

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20CLASS-29"></a>

###### [class](6347) `40ants-lake/configs/install-config:install-config` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHECK-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](1a39) `40ants-lake/configs/install-config:check-func` (install-config) (:check-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHMOD-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](c091) `40ants-lake/configs/install-config:chmod-to` (install-config) (:chmod = \*default-chmod\*)

A mask like 600 to chmod file after creation. If not given, it will be 600

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHOWN-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](3f86) `40ants-lake/configs/install-config:chown-to` (install-config) (:chown)

A user:group to chown file to. If not given, then it will belong current user.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AON-UPDATE-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](041f) `40ants-lake/configs/install-config:on-update-func` (install-config) (:on-update-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATARGET-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](2d5f) `40ants-lake/configs/install-config:target-filename` (install-config) (:target-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](c202) `40ants-lake/configs/install-config:template-filename` (install-config) (:template-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-PARTIALS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](7f7f) `40ants-lake/configs/install-config:template-partials` (install-config) (:partials)

Alist of where key is a string name of the partial and value is a template filename.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-VARS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](ad2a) `40ants-lake/configs/install-config:template-vars` (install-config) (:template-vars)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20FUNCTION-29"></a>

##### [function](e115) `40ants-lake/configs/install-config:install-config` template-name target-filename &rest template-vars &key check-func on-update-func partials (chmod \*default-chmod\*) chown &allow-other-keys

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENV-VAL

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENV-VAL-22-29-20PACKAGE-29"></a>

#### [package](eb8d) `40ants-lake/env-val`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-24ENV-VAL-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ENV-VAL

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20CLASS-29"></a>

###### [class](f120) `40ants-lake/env-val:env-val` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ADEV-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](ed3f) `40ants-lake/env-val:dev-value` (env-val) (:dev = nil)

<a id="x-2840ANTS-LAKE-2FENV-VAL-3APROD-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](8cd7) `40ants-lake/env-val:prod-value` (env-val) (:prod = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20FUNCTION-29"></a>

##### [function](85b6) `40ants-lake/env-val:env-val` &key prod dev

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ARESOLVE-ENV-VALUE-20FUNCTION-29"></a>

##### [function](ecb7) `40ants-lake/env-val:resolve-env-value` value &key (env \*current-environment\*)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENVIRONMENT-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENVIRONMENT

<a id="x-28-23A-28-2823-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENVIRONMENT-22-29-20PACKAGE-29"></a>

#### [package](c395) `40ants-lake/environment`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-DEV-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](7fa6) `40ants-lake/environment:add-dev-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-PROD-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](5654) `40ants-lake/environment:add-prod-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AASSERT-VALID-ENVIRONMENT-20FUNCTION-29"></a>

##### [function](8da4) `40ants-lake/environment:assert-valid-environment` env

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3ALOAD-ENV-FILE-20FUNCTION-29"></a>

##### [function](06c7) `40ants-lake/environment:load-env-file`

Loads .env file with lines like:

```
TOKEN=foo
PORT=100500
```
<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AWITH-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](4a5f) `40ants-lake/environment:with-environment` (environment) &body body

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ERRORS

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](9284) `40ants-lake/errors`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-24LAKE-ERROR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LAKE-ERROR

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20CONDITION-29"></a>

###### [condition](c13d) `40ants-lake/errors:lake-error` (error)

**Readers**

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FERRORS-3ALAKE-ERROR-29-29"></a>

###### [reader](c13d) `40ants-lake/errors:lake-error-message` (lake-error) (:message)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20FUNCTION-29"></a>

##### [function](3709) `40ants-lake/errors:lake-error` message &rest args

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FINSTALLATION-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/INSTALLATION

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FINSTALLATION-22-29-20PACKAGE-29"></a>

#### [package](0e02) `40ants-lake/installation`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FINSTALLATION-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FINSTALLATION-3ACOLLECT-INSTALLATION-STEPS-20GENERIC-FUNCTION-29"></a>

##### [generic-function](8a7d) `40ants-lake/installation:collect-installation-steps` app-or-component

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FPERFORM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/PERFORM

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FPERFORM-22-29-20PACKAGE-29"></a>

#### [package](8cdc) `40ants-lake/perform`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FPERFORM-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FPERFORM-3APERFORM-20GENERIC-FUNCTION-29"></a>

##### [generic-function](e3c1) `40ants-lake/perform:perform` step

Performs an installation step.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FUTILS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/UTILS

<a id="x-28-23A-28-2817-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FUTILS-22-29-20PACKAGE-29"></a>

#### [package](f19a) `40ants-lake/utils`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FUTILS-3AALIAS-20FUNCTION-29"></a>

##### [function](1096) `40ants-lake/utils:alias` alias-name existing-task-name

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-FULL-PATH-20FUNCTION-29"></a>

##### [function](ff46) `40ants-lake/utils:get-full-path` path

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `deploy/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-SYSTEM-PATH-20FUNCTION-29"></a>

##### [function](e8a6) `40ants-lake/utils:get-system-path` PATH &KEY (PREFIX "deploy/")

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `/home/username/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3ANAMESTRING-IF-EXISTS-20FUNCTION-29"></a>

##### [function](4068) `40ants-lake/utils:namestring-if-exists` path-or-string


[5e55]: https://40ants.com/40ants-lake/
[4665]: https://github.com/40ants/40ants-lake
[822c]: https://github.com/40ants/40ants-lake/actions
[a077]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L1
[5df0]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L25
[575d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L26
[31a7]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L29
[d9a0]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L34
[c686]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L41
[b157]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L47
[fbec]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/app.lisp#L52
[4317]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L1
[311f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L32
[589d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L33
[e109]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L37
[b5ad]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L43
[690d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/daemon.lisp#L94
[c607]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L1
[c603]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L112
[d0d6]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L113
[a1cb]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L119
[9b54]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L120
[f5f4]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L125
[782d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L132
[98e5]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L34
[a89b]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L35
[aac4]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L38
[eb73]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/component/webservice.lisp#L43
[01da]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L1
[6347]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L33
[c202]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L34
[2d5f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L37
[ad2a]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L40
[7f7f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L43
[3f86]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L47
[c091]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L51
[1a39]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L56
[041f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L60
[e115]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/configs/install-config.lisp#L93
[eb8d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L1
[f120]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L13
[8cd7]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L14
[ed3f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L17
[85b6]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L22
[ecb7]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/env-val.lisp#L35
[c395]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L1
[8da4]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L23
[4a5f]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L29
[7fa6]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L36
[5654]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L47
[06c7]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/environment.lisp#L59
[9284]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/errors.lisp#L1
[c13d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/errors.lisp#L10
[3709]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/errors.lisp#L18
[0e02]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/installation.lisp#L1
[8a7d]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/installation.lisp#L7
[8cdc]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/perform.lisp#L1
[e3c1]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/perform.lisp#L7
[f19a]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/utils.lisp#L1
[1096]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/utils.lisp#L16
[ff46]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/utils.lisp#L38
[e8a6]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/utils.lisp#L50
[4068]: https://github.com/40ants/40ants-lake/blob/e2188397b05074c154634e12750c7f736443b02c/src/utils.lisp#L74
[43ae]: https://github.com/40ants/40ants-lake/issues
[8236]: https://quickdocs.org/alexandria
[1499]: https://quickdocs.org/cl-ansi-text
[1dd0]: https://quickdocs.org/cl-mustache
[4339]: https://quickdocs.org/lake
[e72d]: https://quickdocs.org/lparallel
[c41d]: https://quickdocs.org/serapeum
[ef7f]: https://quickdocs.org/str

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
