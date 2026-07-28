# dev-buildbox

[![Build](https://github.com/CloudTooling/dev-buildbox/actions/workflows/build.yml/badge.svg)](https://github.com/CloudTooling/dev-buildbox/actions/workflows/build.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/cloudtooling/dev-buildbox)](https://hub.docker.com/r/cloudtooling/dev-buildbox)

Buildbox image for common dev use case

Tools installed:

* Java
  * JDK 17, 21 & 25 (Default JDK 17)
  * Maven
* NodeJS, NVM, yarn, npm
* git
* glab CLI
* changelog-cli
* kubectl, helm, helmfile, helmdocs
* ansible (including [ansible-docsmith](https://github.com/foundata/ansible-docsmith)), docker, shellcheck, yamllint
* jq, yq


Can be directly used in gitlab ci:

```
default:
  image: cloudtooling/dev-buildbox:1.0.0
```
