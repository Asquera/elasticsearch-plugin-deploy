# elasticsearch-plugin-deploy

scripts that deploys a collection of ES plugins to either a local webserver or to heroku

# Usage

## Deploy local

Deploy to `<path>`
```Bash
  $ ./deploy_plugins.sh -l <path>
```

## Deploy to heroku

Deploys to heroku, clones git repositories to `plugins/`
```Bash
  $ ./deploy_plugins.sh -h
```
