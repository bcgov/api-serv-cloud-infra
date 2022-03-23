# AWS Secrets Injector

The aws secrets injector app can read secrets from AWS secrets manager and generate files containing the secret value.

## Prerequsites

- python 3.9
- poetry
- configure environmental variables
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - AWS_DEFAULT_REGION
  - AWS_SECRETS (dictionary string, default: """{}""")
  - FILE_PATH (path to store secrets)

## Installation

### Locally

- `poetry shell` to create virtual environment. If it does not work, use `source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"`
- `poetry install` to install all the dependencies
- `python main.py` to run the app