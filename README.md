# CircleCI Workflow for Alfred 3

**This workflow was inspired by [this awesome project](https://github.com/glidenote/alfred-circleci-projects-workflow).**

![]( ./images/alfred-circleci-projects-workflow00.png)
![]( ./images/alfred-circleci-projects-workflow01.png)

## Setup

1. Clone and build the workflow

### Setting Workflow Environment Variables

1. Generate your CircleCI api token https://circleci.com/account/api
1. Set your CircleCI token in `Workflow Environment Variables`
1. `CIRCLECI_TOKEN`

![](./images/Alfred_Preferences0.png)
![](./images/Alfred_Preferences1.png)


## Commands

### ciu

Cache api response to `/var/tmp/circleci.json`

### ci

Open CircleCI Projects Page.
`ci` command uses cache file `/var/tmp/circleci.json`

### cis

Check build status for branch or project.
`cis` command uses CircleCI api server.

### ciw

Open CircleCI Workflows Page.
`ciw` command uses cache file `/var/tmp/circleci.json`

### cip

Open CircleCI Pipelines Page.
`cip` command uses cache file `/var/tmp/circleci.json`
