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

40ants-lake adds shared tasks to Lake, a task runner for Common Lisp projects.
The tasks build applications, install service configuration, deploy releases, and access Postgre`SQL` databases.

Load the library in a Lisp environment with Quicklisp:

```lisp
(ql:quickload :40ants-lake)
```
To use the Ultralisp distribution, add it before you load the library:

```lisp
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :40ants-lake)
```
Install the Lake command before you use the shell examples.
Build commands require Qlot, Roswell, and the selected Lisp implementation.
Commands for services and databases target Linux.
Service commands require systemd and permission to run the applicable commands through `sudo`.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Define an application

Create a `Lakefile` in the application project root:

```lisp
(ql:quickload :40ants-lake)

(40ants-lake/app:defapps
  (40ants-lake/app:app "my-app"
    :builder t
    :lisp "sbcl-bin"
    :revisions-to-keep 3
    :health-check-url "http://localhost:8080/health"))
```
Replace `my-app` with the application name.
For this builder configuration, the name must also identify the system that 40ants-builder builds.
The application project must provide that system and its build configuration.
Make 40ants-builder available in the application's Qlot environment.

The `DEFAPPS` macro replaces the list of applications for subsequent tasks.
Each `APP` form describes one application.
Most commands process all applications in this list.
The database commands use only the first application.

Run commands from the application project root:

```sh
lake help
lake build
```
The `help` command lists the available tasks.
The default task also displays help.
The `build` command builds every application in the list.

The `:lisp` option selects a Roswell implementation.
Its default value is `sbcl-bin`.
For example, use `ccl-bin/1.13` to select that `CCL` version.
Use `nil` to omit the Roswell implementation option.
The generated command then includes `--non-interactive`, so the default implementation must accept that option.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40COMMANDS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Command reference

| Command | Action |
| --- | --- |
| `lake` or `lake help` | List tasks. |
| `lake build` | Build every application, even when a previous binary exists. |
| `lake install` | Install component configuration for both development and production. |
| `lake to-prod` | Deploy every application locally. |
| `lake start` | Start development services for applications with a daemon component. |
| `lake stop` | Stop development services for applications with a daemon component. |
| `lake restart` | Restart development services for applications with a daemon component. |
| `lake 'start[prod]'` | Start production services for applications with a daemon component. |
| `lake 'stop[prod]'` | Stop production services for applications with a daemon component. |
| `lake 'restart[prod]'` | Restart production services for applications with a daemon component. |
| `lake dbshell` | Open a PostgreSQL session with `psql`. |
| `lake dbdump-schema` | Write `schema.sql`, excluding the `_timescaledb_internal` schema. |
| `lake dbdump-backup` | Write a backup in directory format to `db/backup.dump`. |

The service commands accept `dev` or `prod` as the environment argument.
The default environment is `dev`.
For `my-app`, development commands use `my-app-dev` as the service name.
Production commands use `my-app` as the service name.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40RELEASES-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Build and deploy releases

<a id="build-selection"></a>

### Build selection

40ants-lake selects 40ants-builder when `:builder` is true or the project root contains `build.lisp`.
The presence of `build.lisp` selects this mode for compatibility.
40ants-lake does not execute that file.
It calls `40ants-builder:build` in a separate Roswell process within the project's Qlot environment.

Other applications use the legacy command:

```sh
qlot exec ros dynamic-space-size=32gb build roswell/my-app.ros
```
<a id="prepare-the-host"></a>

### Prepare the host

Release deployment requires an existing `/srv/services/my-app` directory and a system user named `my-app`.
It also requires an existing systemd service named `my-app`.
Configure that service to execute `/srv/services/my-app/current/bin/my-app`.
The release helper does not create the user or the service configuration.
The executable must accept `--version` and return success under the service user.

Release deployment and legacy component installation use different executable paths.
The daemon component generates paths under `roswell/`.
Prepare the systemd configuration separately for releases under `/srv/services/`.

<a id="install-a-release"></a>

### Install a release

To force a new build before deployment, run these commands in order:

```sh
lake build
lake to-prod
```
In builder mode, `to-prod` reuses `bin/` when it contains a file other than a shared library.
This check does not establish that the binary matches the current source or application name.
If the check fails, `to-prod` builds the application first.

The release process performs these steps:

1. Copy the configured files into a temporary staging directory.
2. Write the project's Git revision to `REVISION`.
3. Copy the staging directory into `/srv/services/my-app/releases/<timestamp>` through the bundled `install-release` script.
4. Run `bin/my-app --version` as the service user.
5. Change the `current` symbolic link to the new release with an atomic rename.
6. Reload systemd configuration.
7. Restart the service.
8. Remove old releases according to `:revisions-to-keep`.
9. Check service status after a three-second delay.

The helper removes a release when its version check fails.
It leaves `current` unchanged in that case.
A later failure does not trigger an automatic return to the previous release.
The default retention count is three releases.
Retention does not remove the release that `current` references.

If `:health-check-url` is present, deployment also runs curl with a five-second timeout.
The command prints the `HTTP` status code.
It does not reject an `HTTP` error status as a deployment failure.

<a id="select-release-contents"></a>

### Select release contents

The default `:release-paths` value copies `bin/` into the release's `bin/` directory.
Each pair has the form `(destination . source)`.
Source paths are relative to the application project root.
Destination paths are relative to the staging directory.
Directory sources require a final slash.

```lisp
:release-paths '(("bin" . "bin/")
                 ("assets" . "assets/"))
:extra-revisions '(("ASSETS_REVISION" . "assets/"))
```
Each `:extra-revisions` pair names an output file and a nested Git repository.
The staging process writes that repository's revision into the specified file.

<a id="restore-an-earlier-release"></a>

### Restore an earlier release

Use the bundled helper with an existing release directory name:

```sh
sudo /path/to/40ants-lake/scripts/install-release --switch my-app 20261115-120000
```
Replace the script path and timestamp with the actual values.
This command changes `current` and restarts the service.
It does not run retention or the version check.

<a id="legacy-deployment"></a>

### Legacy deployment

In legacy mode, `to-prod` copies `roswell/my-app` to `roswell/my-app-prod` when the source binary exists.
It then requests a restart of production daemon applications.
Build the legacy binary before deployment.
The `:target-host` option currently causes deployment to report an error.
Remote deployment is not supported.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40COMPONENTS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Configure legacy services

Components describe configuration files for legacy applications.
A daemon component generates systemd configuration.
A webservice component generates nginx configuration with proxy routes.

This example defines different settings for development and production:

```lisp
(ql:quickload :40ants-lake)

(40ants-lake/app:defapps
  (40ants-lake/app:app "my-app"
    :components
    (list
      (40ants-lake/component/daemon:daemon
        :user "my-app"
        :environment
        (list (cons "PORT"
                    (40ants-lake/env-val:env-val
                      :dev "8081" :prod "8080"))))
      (40ants-lake/component/webservice:webservice
        (40ants-lake/env-val:env-val
          :dev "dev.example.com" :prod "example.com")
        :routes
        (list (40ants-lake/component/webservice:proxy
                "/" (40ants-lake/env-val:env-val
                       :dev 8081 :prod 8080)))))))
```
Use this sequence after you provide `roswell/my-app.ros`:

```sh
lake build
lake to-prod
lake install
```
The daemon configuration requires both `roswell/my-app` and `roswell/my-app-prod`.
The `install` command writes configuration for both environments.
Changed daemon configuration triggers a systemd reload and a service restart.
The daemon user defaults to the `USER` environment variable, or `root` when that variable is absent.
Specify `:user` to select the intended account.

Webservice installation requires nginx and Certbot.
40ants-lake checks the nginx configuration before installation.
Changed webservice configuration triggers an nginx reload and a Certbot request for the host and its `www` name.
Ensure that these names refer to the intended server before installation.

`ENV-VAL` selects its `:dev` or `:prod` value from the current environment.
An ordinary value remains the same in both environments.
A missing host value skips webservice configuration for that environment.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40DATABASE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Access a database

Database commands require an application in `DEFAPPS` and Postgre`SQL` client tools.
They use configuration sources in this order:

1. Load `.local-config.lisp` from the project root when that file exists.
2. Otherwise, read `/srv/services/<name>/config/service.env` for the first application.

An existing `.local-config.lisp` takes precedence even when it does not define all required variables.
The command reports an error if no usable configuration source exists.

Define these variables through the selected configuration source:

| Variable | Meaning |
| --- | --- |
| `DB_HOST` | Database host. |
| `DB_PORT` | Database port. |
| `DB_USER` | Database user. |
| `DB_NAME` | Database name. |
| `DB_PASSWORD` | Database password. |
| `DB_OPTIONS` | Optional PostgreSQL connection options. |

The service file accepts `KEY=value` and `export KEY=value` lines.
Its parser removes matching outer quotes from values.
It ignores comments and blank lines.
Only the listed database variables enter the process environment from this file.
The user who runs Lake must have permission to read the file.

Example `service.env` content:

```text
DB_HOST=localhost
DB_PORT=5432
DB_USER=my_app
DB_NAME=my_app
DB_PASSWORD=replace-with-the-database-password
```
Run `lake dbshell` to open the database session.
The dump tasks prefer `/usr/lib/postgresql/17/bin/pg_dump` when that executable exists.
Otherwise, they use `pg_dump` from the command search path.
Choose a new output directory before you repeat `dbdump-backup`, because `pg_dump` requires a directory that does not exist.

The separate `LOAD-ENV-FILE` function reads simple `KEY=value` lines from `.env` into the process environment.
Call it explicitly when your Lakefile requires it.
Loading 40ants-lake does not call it automatically.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40DEVELOPMENT-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Build this documentation

The documentation source is `docs/index.lisp`.
40ants-doc generates the `README` and `HTML` from that source and the library's public definitions.

Run the strict build from this repository's Qlot environment:

```sh
qlot exec ros -L sbcl-bin run -- --non-interactive \
  --eval '(push (uiop:getcwd) asdf:*central-registry*)' \
  --eval '(ql:quickload (list "docs-builder" "40ants-lake-docs"))' \
  --eval '(docs-builder:build "40ants-lake-docs" :error-on-warnings t :local t)'
```
Check the build output for documentation warnings before you use the generated files.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/APP

<a id="x-28-23A-28-2815-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FAPP-22-29-20PACKAGE-29"></a>

#### [package](f027) `40ants-lake/app`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FAPP-24APP-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### APP

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20CLASS-29"></a>

###### [class](871f) `40ants-lake/app:app` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-BUILDER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](5f19) `40ants-lake/app:app-builder` (app) (:builder = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-COMPONENTS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](813e) `40ants-lake/app:app-components` (app) (:components)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](3757) `40ants-lake/app:app-extra-revisions` (app) (:extra-revisions = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](f602) `40ants-lake/app:app-health-check-url` (app) (:health-check-url = nil)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-LISP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](8648) `40ants-lake/app:app-lisp` (app) (:LISP = "sbcl-bin")

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-NAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](1eb2) `40ants-lake/app:app-name` (app) (:name)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](ab83) `40ants-lake/app:app-release-paths` (app) (:RELEASE-PATHS = '(("bin" . "bin/")))

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-REVISIONS-TO-KEEP-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](7f3c) `40ants-lake/app:app-revisions-to-keep` (app) (:revisions-to-keep = 3)

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-TARGET-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29"></a>

###### [reader](c775) `40ants-lake/app:app-target-host` (app) (:target-host = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILD-APP-20GENERIC-FUNCTION-29"></a>

##### [generic-function](b42e) `40ants-lake/app:build-app` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FAPP-3AAPP-20FUNCTION-29"></a>

##### [function](2323) `40ants-lake/app:app` NAME &KEY COMPONENTS TARGET-HOST (REVISIONS-TO-KEEP 3) (RELEASE-PATHS '(("bin" . "bin/"))) EXTRA-REVISIONS (LISP "sbcl-bin") BUILDER HEALTH-CHECK-URL

<a id="x-2840ANTS-LAKE-2FAPP-3ABIN-READY-P-20FUNCTION-29"></a>

##### [function](1b73) `40ants-lake/app:bin-ready-p` &optional (root (uiop/os:getcwd))

Return T when `ROOT`/bin holds a build that can be released as-is.

The directory exists and contains at least one file that is not a
shared library. Deploy fills bin/ with the executable plus *.so
libraries, so a bin/ holding only libraries means the executable
artifact is missing and the build has to run. 'lake to-prod' uses this
to deploy the already built binary; 'lake build' keeps rebuilding
unconditionally.

<a id="x-2840ANTS-LAKE-2FAPP-3ABUILDER-TRACT-P-20FUNCTION-29"></a>

##### [function](5845) `40ants-lake/app:builder-tract-p` app root

Return T when `APP` builds through the 40ants-builder library.

T is returned either when the app passes the `BUILDER` slot or, for
backward compatibility, when `ROOT` contains a build.lisp. Other apps
keep using the legacy roswell/<name>.ros build.

<a id="x-2840ANTS-LAKE-2FAPP-3ACURRENT-APP-20FUNCTION-29"></a>

##### [function](9542) `40ants-lake/app:current-app`

<a id="x-2840ANTS-LAKE-2FAPP-3ADELETE-STALE-ARTIFACT-20FUNCTION-29"></a>

##### [function](d039) `40ants-lake/app:delete-stale-artifact` app

Delete the previous bin/<name> artifact, if any.

`ASDF` skips deploy-op when its output file is newer than the inputs, so
without this a build would silently keep the stale binary when nothing
tracked changed — for example right after switching the `LISP` slot from
one implementation to another.

<a id="x-2840ANTS-LAKE-2FAPP-3ALEGACY-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](2b9d) `40ants-lake/app:legacy-build-command` name

Return the legacy build command for projects without build.lisp.

<a id="x-2840ANTS-LAKE-2FAPP-3ARELEASE-BUILD-COMMAND-20FUNCTION-29"></a>

##### [function](59b7) `40ants-lake/app:release-build-command` app

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

##### [function](23a0) `40ants-lake/app:uses-build-lisp-p` root

Return T when `ROOT` contains a build.lisp.

The file was the marker of the Deploy tract back when lake executed
it directly. It is kept for backward compatibility: projects with
build.lisp still build through the 40ants-builder library, but the
file itself is not executed anymore.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FAPP-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FAPP-3ADEFAPPS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](8dc8) `40ants-lake/app:defapps` &body apps

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMMANDS-2FDB-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMMANDS/DB

<a id="x-28-23A-28-2823-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMMANDS-2FDB-22-29-20PACKAGE-29"></a>

#### [package](8001) `40ants-lake/commands/db`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMMANDS-2FDB-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FDB-3AENSURE-DB-CONNECTION-ENV-20FUNCTION-29"></a>

##### [function](fe4b) `40ants-lake/commands/db:ensure-db-connection-env` app

Prepare the process environment for a psql/pg_dump connection.

Sources in priority order:
1. `.local-config.lisp` in the project root (it sets `DB`_* variables itself).
2. `/srv/services/<name>/config/service.env` of the deployed service.
Signals a `lake-error` ([`1`][d96a] [`2`][cd1c]) when neither source is available.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FDB-3AGET-PG-CONN-STRING-20FUNCTION-29"></a>

##### [function](31eb) `40ants-lake/commands/db:get-pg-conn-string`

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FDB-3ASERVICE-ENV-PATH-20FUNCTION-29"></a>

##### [function](e4f4) `40ants-lake/commands/db:service-env-path` app

Path to the deployed service's environment file, readable by group art.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMMANDS/TO-PROD

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMMANDS-2FTO-PROD-22-29-20PACKAGE-29"></a>

#### [package](74c7) `40ants-lake/commands/to-prod`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3ADEPLOY-APP-20FUNCTION-29"></a>

##### [function](268c) `40ants-lake/commands/to-prod:deploy-app` app

Deploy a single `APP` and return the deploy mode used.

Apps of the Deploy tract (marked by a build.lisp in the project root,
built via the 40ants-builder library) are installed as /srv/services
releases via the install-release helper; apps without it fall back to
the legacy roswell binary copying. Remote targets are not supported yet.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AHEALTH-CHECK-COMMANDS-20FUNCTION-29"></a>

##### [function](b8e9) `40ants-lake/commands/to-prod:health-check-commands` app

Return shell commands verifying that the service of `APP` is alive.

Always includes `systemctl is-active`; when [`app-health-check-url`][529f] is set,
also a curl returning the `HTTP` code (000 means nothing is listening).

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-COMMAND-20FUNCTION-29"></a>

##### [function](60a7) `40ants-lake/commands/to-prod:install-release-command` name staging keep

Return the command installing `STAGING` as a new release of the service `NAME`.

The helper is the single write entry point into /srv/services: it copies
the revision, runs the smoke test as the service user, atomically flips
`current`, restarts the service and prunes old revisions down to `KEEP`.

<a id="x-2840ANTS-LAKE-2FCOMMANDS-2FTO-PROD-3AINSTALL-RELEASE-SCRIPT-PATH-20FUNCTION-29"></a>

##### [function](be21) `40ants-lake/commands/to-prod:install-release-script-path`

Return the absolute path of the install-release helper shipped in the 40ants-lake checkout.

The helper lives next to the lake sources and is always in sync with the
running code; no host-wide copy in /usr/local/sbin is required.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/DAEMON

<a id="x-28-23A-28-2828-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FDAEMON-22-29-20PACKAGE-29"></a>

#### [package](f113) `40ants-lake/component/daemon`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-24DAEMON-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### DAEMON

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20CLASS-29"></a>

###### [class](f4c1) `40ants-lake/component/daemon:daemon` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](7613) `40ants-lake/component/daemon:daemon-environment` (daemon) (:environment = nil)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-USER-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-29-29"></a>

###### [reader](adb8) `40ants-lake/component/daemon:daemon-user` (daemon) (:USER = "root")

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FDAEMON-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3ADAEMON-20FUNCTION-29"></a>

##### [function](4c85) `40ants-lake/component/daemon:daemon` &KEY ENVIRONMENT (USER (OR (UIOP/OS:GETENV "USER") "root"))

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FDAEMON-3AHAS-DAEMON-COMPONENT-P-20FUNCTION-29"></a>

##### [function](a3b9) `40ants-lake/component/daemon:has-daemon-component-p` app

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/COMPONENT/WEBSERVICE

<a id="x-28-23A-28-2832-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-22-29-20PACKAGE-29"></a>

#### [package](502e) `40ants-lake/component/webservice`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24PROXY-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PROXY

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20CLASS-29"></a>

###### [class](97b5) `40ants-lake/component/webservice:proxy` (route)

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](a743) `40ants-lake/component/webservice:backend-host` (proxy) (:HOST = "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3ABACKEND-PORT-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-29-29"></a>

###### [reader](7f6e) `40ants-lake/component/webservice:backend-port` (proxy) (:port = (required-argument :port))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24ROUTE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ROUTE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-20CLASS-29"></a>

###### [class](57a0) `40ants-lake/component/webservice:route` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AURL-PREFIX-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AROUTE-29-29"></a>

###### [reader](baca) `40ants-lake/component/webservice:url-prefix` (route) (:url-prefix = (required-argument :url-prefix))

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-24WEBSERVICE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### WEBSERVICE

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20CLASS-29"></a>

###### [class](de49) `40ants-lake/component/webservice:webservice` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-HOST-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](6127) `40ants-lake/component/webservice:webservice-host` (webservice) (:host)

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-ROUTES-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-29-29"></a>

###### [reader](f8db) `40ants-lake/component/webservice:webservice-routes` (webservice) (:routes)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3APROXY-20FUNCTION-29"></a>

##### [function](5f97) `40ants-lake/component/webservice:proxy` URL-PREFIX PORT &KEY (HOST "localhost")

<a id="x-2840ANTS-LAKE-2FCOMPONENT-2FWEBSERVICE-3AWEBSERVICE-20FUNCTION-29"></a>

##### [function](9bae) `40ants-lake/component/webservice:webservice` host &key routes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/CONFIGS/INSTALL-CONFIG

<a id="x-28-23A-28-2834-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-22-29-20PACKAGE-29"></a>

#### [package](60ac) `40ants-lake/configs/install-config`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-24INSTALL-CONFIG-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### INSTALL-CONFIG

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20CLASS-29"></a>

###### [class](419b) `40ants-lake/configs/install-config:install-config` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHECK-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](2664) `40ants-lake/configs/install-config:check-func` (install-config) (:check-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHMOD-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](38b2) `40ants-lake/configs/install-config:chmod-to` (install-config) (:chmod = \*default-chmod\*)

A mask like 600 to chmod file after creation. If not given, it will be 600

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ACHOWN-TO-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](54e2) `40ants-lake/configs/install-config:chown-to` (install-config) (:chown)

A user:group to chown file to. If not given, then it will belong current user.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AON-UPDATE-FUNC-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](a04c) `40ants-lake/configs/install-config:on-update-func` (install-config) (:on-update-func = nil)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATARGET-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](c0cc) `40ants-lake/configs/install-config:target-filename` (install-config) (:target-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-FILENAME-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](5fd4) `40ants-lake/configs/install-config:template-filename` (install-config) (:template-filename)

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-PARTIALS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](10b3) `40ants-lake/configs/install-config:template-partials` (install-config) (:partials)

Alist of where key is a string name of the partial and value is a template filename.

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3ATEMPLATE-VARS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-29-29"></a>

###### [reader](c959) `40ants-lake/configs/install-config:template-vars` (install-config) (:template-vars)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FCONFIGS-2FINSTALL-CONFIG-3AINSTALL-CONFIG-20FUNCTION-29"></a>

##### [function](ed52) `40ants-lake/configs/install-config:install-config` template-name target-filename &rest template-vars &key check-func on-update-func partials (chmod \*default-chmod\*) chown &allow-other-keys

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENV-VAL

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENV-VAL-22-29-20PACKAGE-29"></a>

#### [package](96a4) `40ants-lake/env-val`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENV-VAL-24ENV-VAL-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### ENV-VAL

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20CLASS-29"></a>

###### [class](4477) `40ants-lake/env-val:env-val` ()

**Readers**

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ADEV-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](3995) `40ants-lake/env-val:dev-value` (env-val) (:dev = nil)

<a id="x-2840ANTS-LAKE-2FENV-VAL-3APROD-VALUE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FENV-VAL-3AENV-VAL-29-29"></a>

###### [reader](8c98) `40ants-lake/env-val:prod-value` (env-val) (:prod = nil)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENV-VAL-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENV-VAL-3AENV-VAL-20FUNCTION-29"></a>

##### [function](6623) `40ants-lake/env-val:env-val` &key prod dev

<a id="x-2840ANTS-LAKE-2FENV-VAL-3ARESOLVE-ENV-VALUE-20FUNCTION-29"></a>

##### [function](ad97) `40ants-lake/env-val:resolve-env-value` value &key (env \*current-environment\*)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FENVIRONMENT-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ENVIRONMENT

<a id="x-28-23A-28-2823-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FENVIRONMENT-22-29-20PACKAGE-29"></a>

#### [package](5b43) `40ants-lake/environment`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-DEV-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](cbbc) `40ants-lake/environment:add-dev-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AADD-PROD-SUFFIX-IF-NEEDED-20FUNCTION-29"></a>

##### [function](8db5) `40ants-lake/environment:add-prod-suffix-if-needed` string &key (delimiter "-")

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AASSERT-VALID-ENVIRONMENT-20FUNCTION-29"></a>

##### [function](c5ff) `40ants-lake/environment:assert-valid-environment` env

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3ALOAD-ENV-FILE-20FUNCTION-29"></a>

##### [function](600d) `40ants-lake/environment:load-env-file`

Loads .env file with lines like:

```
TOKEN=foo
PORT=100500
```
<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FENVIRONMENT-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-2840ANTS-LAKE-2FENVIRONMENT-3AWITH-ENVIRONMENT-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](7db9) `40ants-lake/environment:with-environment` (environment) &body body

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/ERRORS

<a id="x-28-23A-28-2818-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FERRORS-22-29-20PACKAGE-29"></a>

#### [package](731c) `40ants-lake/errors`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FERRORS-24LAKE-ERROR-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### LAKE-ERROR

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20CONDITION-29"></a>

###### [condition](db77) `40ants-lake/errors:lake-error` (error)

**Readers**

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-MESSAGE-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FERRORS-3ALAKE-ERROR-29-29"></a>

###### [reader](db77) `40ants-lake/errors:lake-error-message` (lake-error) (:message)

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FERRORS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20FUNCTION-29"></a>

##### [function](e2f2) `40ants-lake/errors:lake-error` message &rest args

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FINSTALLATION-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/INSTALLATION

<a id="x-28-23A-28-2824-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FINSTALLATION-22-29-20PACKAGE-29"></a>

#### [package](9caf) `40ants-lake/installation`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FINSTALLATION-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FINSTALLATION-3ACOLLECT-INSTALLATION-STEPS-20GENERIC-FUNCTION-29"></a>

##### [generic-function](2366) `40ants-lake/installation:collect-installation-steps` app-or-component

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FPERFORM-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/PERFORM

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FPERFORM-22-29-20PACKAGE-29"></a>

#### [package](11d6) `40ants-lake/perform`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FPERFORM-3FGenerics-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Generics

<a id="x-2840ANTS-LAKE-2FPERFORM-3APERFORM-20GENERIC-FUNCTION-29"></a>

##### [generic-function](a668) `40ants-lake/perform:perform` step

Performs an installation step.

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-4040ANTS-LAKE-2FRELEASE-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### 40ANTS-LAKE/RELEASE

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-2240ANTS-LAKE-2FRELEASE-22-29-20PACKAGE-29"></a>

#### [package](6690) `40ants-lake/release`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FRELEASE-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FRELEASE-3AMAKE-STAGING-20FUNCTION-29"></a>

##### [function](f6e7) `40ants-lake/release:make-staging` app root

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

#### [package](5e1f) `40ants-lake/utils`

<a id="x-2840ANTS-LAKE-DOCS-2FINDEX-3A-3A-7C-4040ANTS-LAKE-2FUTILS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-2840ANTS-LAKE-2FUTILS-3AALIAS-20FUNCTION-29"></a>

##### [function](3160) `40ants-lake/utils:alias` alias-name existing-task-name

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-FULL-PATH-20FUNCTION-29"></a>

##### [function](868d) `40ants-lake/utils:get-full-path` path

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `deploy/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3AGET-SYSTEM-PATH-20FUNCTION-29"></a>

##### [function](b339) `40ants-lake/utils:get-system-path` PATH &KEY (PREFIX "deploy/")

For a path like `deploy/$HOME/.local/share/systemd/user/app.service`
returns `/home/username/.local/share/systemd/user/app.service`

<a id="x-2840ANTS-LAKE-2FUTILS-3ANAMESTRING-IF-EXISTS-20FUNCTION-29"></a>

##### [function](7845) `40ants-lake/utils:namestring-if-exists` path-or-string


[5e55]: https://40ants.com/40ants-lake/
[f059]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-EXTRA-REVISIONS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[529f]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-HEALTH-CHECK-URL-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[7752]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FAPP-3AAPP-RELEASE-PATHS-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-2040ANTS-LAKE-2FAPP-3AAPP-29-29
[cd1c]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20CONDITION-29
[d96a]: https://40ants.com/40ants-lake/#x-2840ANTS-LAKE-2FERRORS-3ALAKE-ERROR-20FUNCTION-29
[4665]: https://github.com/40ants/40ants-lake
[822c]: https://github.com/40ants/40ants-lake/actions
[f027]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L1
[23a0]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L137
[5845]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L149
[2b9d]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L160
[d039]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L166
[1b73]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L192
[b42e]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L208
[8dc8]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L217
[9542]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L222
[871f]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L39
[1eb2]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L40
[813e]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L43
[c775]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L46
[7f3c]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L50
[ab83]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L54
[3757]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L58
[8648]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L62
[5f19]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L66
[f602]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L70
[2323]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L76
[59b7]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/app.lisp#L98
[8001]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/db.lisp#L1
[31eb]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/db.lisp#L112
[e4f4]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/db.lisp#L32
[fe4b]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/db.lisp#L92
[74c7]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/to-prod.lisp#L1
[268c]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/to-prod.lisp#L134
[be21]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/to-prod.lisp#L41
[60a7]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/to-prod.lisp#L54
[b8e9]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/commands/to-prod.lisp#L68
[f113]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L1
[f4c1]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L32
[7613]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L33
[adb8]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L37
[4c85]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L43
[a3b9]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/daemon.lisp#L94
[502e]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L1
[57a0]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L112
[baca]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L113
[97b5]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L119
[7f6e]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L120
[a743]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L125
[5f97]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L132
[de49]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L34
[6127]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L35
[f8db]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L38
[9bae]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/component/webservice.lisp#L43
[60ac]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L1
[419b]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L33
[5fd4]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L34
[c0cc]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L37
[c959]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L40
[10b3]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L43
[54e2]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L47
[38b2]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L51
[2664]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L56
[a04c]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L60
[ed52]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/configs/install-config.lisp#L93
[96a4]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L1
[4477]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L13
[8c98]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L14
[3995]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L17
[6623]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L22
[ad97]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/env-val.lisp#L35
[5b43]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L1
[c5ff]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L23
[7db9]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L29
[cbbc]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L36
[8db5]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L47
[600d]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/environment.lisp#L59
[731c]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/errors.lisp#L1
[db77]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/errors.lisp#L10
[e2f2]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/errors.lisp#L18
[9caf]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/installation.lisp#L1
[2366]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/installation.lisp#L7
[11d6]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/perform.lisp#L1
[a668]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/perform.lisp#L7
[6690]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/release.lisp#L1
[f6e7]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/release.lisp#L73
[5e1f]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/utils.lisp#L1
[3160]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/utils.lisp#L16
[868d]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/utils.lisp#L38
[b339]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/utils.lisp#L50
[7845]: https://github.com/40ants/40ants-lake/blob/0659fb472eeb8206eb0e111e3c9c4520fd54b5c2/src/utils.lisp#L74
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
