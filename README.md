# Open Play

The Open Play MVP

## Install

Ensure you have PostgreSQL installed and running, and install foreman
with `gem install foreman` in order to run Procfile.dev. ENV variables
will be defined in `.rbenv-vars` so grab that from somebody or create
your own based on `.rbenv-vars.example`.

```
bundle
rake db:migrate
rspec
./bin/local_server
```

Deployment is automatic via CircleCI when pushing to `development` (staging)
and `master` (production).
