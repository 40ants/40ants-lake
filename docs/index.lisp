(uiop:define-package #:40ants-lake-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  #+quicklisp
  (:import-from #:quicklisp)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:40ants-lake-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:import-from #:40ants-doc/autodoc
                #:defautodoc)
  (:export #:@index
           #:@readme
           #:@changelog))
(in-package #:40ants-lake-docs/index)

(in-readtable pythonic-string-syntax)


(defmethod docs-config ((system (eql (asdf:find-system "40ants-lake-docs"))))
  ;; 40ANTS-DOC-THEME-40ANTS system will bring
  ;; as dependency a full 40ANTS-DOC but we don't want
  ;; unnecessary dependencies here:
  #+quicklisp
  (ql:quickload "40ants-doc-theme-40ants")
  #-quicklisp
  (asdf:load-system "40ants-doc-theme-40ants")

  (list :theme
        (find-symbol "40ANTS-THEME"
                     (find-package "40ANTS-DOC-THEME-40ANTS"))))


(defsection @index (:title "40ants-lake - Common Lake commands for 40Ants projects."
                    :ignore-words ("SQL"
                                   "USER"
                                   "README"
                                   "HTML"
                                   "DB"
                                   "JSON"
                                   "HTTP"
                                   "DEFAPPS"
                                   "APP"
                                   "ENV-VAL"
                                   "LOAD-ENV-FILE"
                                   "KEY"
                                   "REVISION"
                                   "ASSETS_REVISION"
                                   "Unlicense"
                                   "REPL"
                                   "ASDF:PACKAGE-INFERRED-SYSTEM"
                                   "ASDF"
                                   "40A"
                                   "API"
                                   "URL"
                                   "URI"
                                   "CCL"
                                   "SBCL"
                                   "ECL"
                                   "HOME"
                                   "RPC"
                                   "GIT"))
  (40ants-lake system)
  "
[![](https://github-actions.40ants.com/40ants/40ants-lake/matrix.svg?only=ci.run-tests)](https://github.com/40ants/40ants-lake/actions)

![Quicklisp](http://quickdocs.org/badge/40ants-lake.svg)
"
  (@installation section)
  (@usage section)
  (@commands section)
  (@releases section)
  (@components section)
  (@database section)
  (@development section)
  (@api section))


(defsection-copy @readme @index)


(defsection @installation (:title "Installation")
  """
40ants-lake adds shared tasks to Lake, a task runner for Common Lisp projects.
The tasks build applications, install service configuration, deploy releases, and access PostgreSQL databases.

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
""")


(defsection @usage (:title "Define an application")
  """
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

The DEFAPPS macro replaces the list of applications for subsequent tasks.
Each APP form describes one application.
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
For example, use `ccl-bin/1.13` to select that CCL version.
Use `nil` to omit the Roswell implementation option.
The generated command then includes `--non-interactive`, so the default implementation must accept that option.
""")


(defsection @commands (:title "Command reference")
  """
| Command | Action |
|---------|--------|
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
""")


(defsection @releases (:title "Build and deploy releases")
  """
### Build selection

40ants-lake selects 40ants-builder when `:builder` is true or the project root contains `build.lisp`.
The presence of `build.lisp` selects this mode for compatibility.
40ants-lake does not execute that file.
It calls `40ants-builder:build` in a separate Roswell process within the project's Qlot environment.

Other applications use the legacy command:

```sh
qlot exec ros dynamic-space-size=32gb build roswell/my-app.ros
```

### Prepare the host

Release deployment requires an existing `/srv/services/my-app` directory and a system user named `my-app`.
It also requires an existing systemd service named `my-app`.
Configure that service to execute `/srv/services/my-app/current/bin/my-app`.
The release helper does not create the user or the service configuration.
The executable must accept `--version` and return success under the service user.

Release deployment and legacy component installation use different executable paths.
The daemon component generates paths under `roswell/`.
Prepare the systemd configuration separately for releases under `/srv/services/`.

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
The command prints the HTTP status code.
It does not reject an HTTP error status as a deployment failure.

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

### Restore an earlier release

Use the bundled helper with an existing release directory name:

```sh
sudo /path/to/40ants-lake/scripts/install-release --switch my-app 20261115-120000
```

Replace the script path and timestamp with the actual values.
This command changes `current` and restarts the service.
It does not run retention or the version check.

### Legacy deployment

In legacy mode, `to-prod` copies `roswell/my-app` to `roswell/my-app-prod` when the source binary exists.
It then requests a restart of production daemon applications.
Build the legacy binary before deployment.
The `:target-host` option currently causes deployment to report an error.
Remote deployment is not supported.
""")


(defsection @components (:title "Configure legacy services")
  """
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

ENV-VAL selects its `:dev` or `:prod` value from the current environment.
An ordinary value remains the same in both environments.
A missing host value skips webservice configuration for that environment.
""")


(defsection @database (:title "Access a database")
  """
Database commands require an application in DEFAPPS and PostgreSQL client tools.
They use configuration sources in this order:

1. Load `.local-config.lisp` from the project root when that file exists.
2. Otherwise, read `/srv/services/<name>/config/service.env` for the first application.

An existing `.local-config.lisp` takes precedence even when it does not define all required variables.
The command reports an error if no usable configuration source exists.

Define these variables through the selected configuration source:

| Variable | Meaning |
|----------|---------|
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

The separate LOAD-ENV-FILE function reads simple `KEY=value` lines from `.env` into the process environment.
Call it explicitly when your Lakefile requires it.
Loading 40ants-lake does not call it automatically.
""")


(defsection @development (:title "Build this documentation")
  """
The documentation source is `docs/index.lisp`.
40ants-doc generates the README and HTML from that source and the library's public definitions.

Run the strict build from this repository's Qlot environment:

```sh
qlot exec ros -L sbcl-bin run -- --non-interactive \
  --eval '(push (uiop:getcwd) asdf:*central-registry*)' \
  --eval '(ql:quickload (list "docs-builder" "40ants-lake-docs"))' \
  --eval '(docs-builder:build "40ants-lake-docs" :error-on-warnings t :local t)'
```

Check the build output for documentation warnings before you use the generated files.
""")


(defautodoc @api (:system "40ants-lake"))
