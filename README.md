# Flakebot CircleCI Orb [![CircleCI Orb Version](https://img.shields.io/badge/endpoint.svg?url=https://badges.circleci.io/orb/flakebot/reporter)](https://circleci.com/orbs/registry/orb/flakebot/reporter) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/flakebot-inc/circleci-reporter/master/LICENSE)

Easily connect your CircleCI jobs to [Flakebot](https://flakebot.com) to identify and eliminate flaking tests.

## Usage

See [this orb's listing in CircleCI's Orbs Registry](https://circleci.com/orbs/registry/orb/flakebot/reporter) for details on usage, or see the example below.

## Example

In this example `config.yml` snippet, after your tests run, the `flakebot/report` command uploads any test artifacts to Flakebot for analysis.

```yaml
description: Report test artifacts to Flakebot
usage:
  version: 2.1

  orbs:
    flakebot: flakebot/reporter@latest

  jobs:
    test:
      docker:
        - image: circleci/alpine:latest
      steps:
        - checkout

        - run: echo "Run your tests and generate test artifacts for your test suite."

        - flakebot/report:
            path: artifacts/test-results.xml
            reporter-key: FLAKEBOT_REPORTER_KEY

  workflows:
    version: 2
  commit:
    jobs:
      - test
```
