# dfmg-template2

A template for [DocFxMarkdownGen](https://github.com/Jan0660/DocFxMarkdownGen) and [Docusaurus](https://docusaurus.io/).
This repository also contains GitHub Actions workflows for automatic documentation generation and deployment to Vercel(just my preference, any should work).

## Get Started

### Prerequisites

- [.NET 6.0](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
- [docfx](https://github.com/dotnet/docfx)\*

```shell
dotnet tool install -g DocFxMarkdownGen
# to update
dotnet tool update -g DocFxMarkdownGen
# * docfx can also be installed as a .NET tool:
dotnet tool install -g docfx
```

If a message telling you to add dotnet tools to your `PATH` after install comes up, do as it says. You should now be able to use the `dfmg` command.

### Create

Replace `dfmg-docs` with your desired project name.

```shell
yarn create docusaurus dfmg-docs https://github.com/Jan0660/dfmg-template2.git
```

The following steps count with the project you are generating documentation being in `../Project`:

- Update `.env`:
  - `PROJECT_REPO` to your project's repository, e.g. `Jan0660/Project`.
  - `PROJECT_NAME` to your .NET project name.
  - `PROJECT_BRANCH` to the branch you want to generate documentation for.
- In `docfx.json` change `Project` to your `PROJECT_NAME` you set in `.env` earlier and also check "src" matches your project structure.
- Do the following for the workflows in `.github/workflows/` if you wish to keep them:
  - If different, change `main` to your main/production branch name(of the documentation repository).
  - For Vercel, set up the secrets (one of the passages [here](https://vercel.com/guides/how-can-i-use-github-actions-with-vercel#configuring-github-actions-for-vercel) will help you).
  - For GitHub Pages, it seems you have to do [this](https://github.com/peaceiris/actions-gh-pages/issues/744#issuecomment-1119685318) for it to work.

Done! All you need to do now is to edit `docusaurus.config.js` to suit your project and generate api documentation with the `generate.sh` script.

### workflow_dispatch

If you kept the GitHub Actions you will need extra setup so that your documentation updates when you push to your .NET project.

- on the .NET repository:
  1. set up a personal access token with with access to your documentation repository, and set it as a secret named `PAT_TOKEN`. Also set `PAT_USERNAME` as your username.
  2. Add the following workflow to `.github/workflows/`. Replace `YOURNAME` with your GitHub username and `REPONAME` with your documentation repository name.

     ```yml
     name: Update Documentation
     on:
       push:
         branches:
           - main
     jobs:
       update:
         runs-on: ubuntu-latest
         steps:
           - name: Trigger Documentation Update (preview-deploy-vercel)
             run: |
               curl -XPOST -u "${{ secrets.PAT_USERNAME}}:${{secrets.PAT_TOKEN}}" -H "Accept: application/vnd.github.everest-preview+json" -H "Content-Type: application/json" https://api.github.com/repos/YOURNAME/REPONAME/actions/workflows/preview-deploy-vercel.yaml/dispatches --data '{"ref": "master"}'
     ```

  3. Cheers! Now whenever you push to your .NET project, the documentation will be updated.
- Everything should be set up already on the documentation repository, since `on.workflow_dispatch` is already set up in `.github/workflows/preview-deploy-vercel.yaml`.

## Building locally

### Without API documentation

1. Clone this repository.
2. `yarn install`
3. `yarn start`

### With API documentation

1. Get [.NET 6.0](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
2. Install the needed .NET tools. If a message telling you to add dotnet tools to your `PATH` after install comes up, do as it says.

   ```shell
   dotnet tool install -g DocFxMarkdownGen
   # * docfx can also be installed as a .NET tool:
   dotnet tool install -g docfx
   # to update these: dotnet tool update -g 'toolname'
   ```

3. Clone [Project](https://github.com/Jan0660/Project).
4. Clone this repository and `cd` into it. `Project` should now be at `../Project`.
5. Run `generate.sh` to generate the API documentation. You need bash for this.
6. `yarn install`
7. `yarn start`
8. Done.
