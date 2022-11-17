# V1.0

## Folder structure overview

- `/api`: the NodeJs Azure Function code used to provide the backend API, called by the Vue.Js client. 
- `/client`: the Vue.Js client. Original source code has been taken from official Vue.js sample and adapted to call a REST client instead of using local storage to save and retrieve todos

## Install the dependencies

Make sure you have [Node](https://nodejs.org/en/download/) as it is required by Azure Functions Core Tools and also by Azure Static Web Apps. The backend API will be using .NET Core, but Node is needed to have the local development experience running nicely.

Also install the [Azure Function Core Tools v4](https://www.npmjs.com/package/azure-functions-core-tools):

```sh
npm i -g azure-functions-core-tools@4 --unsafe-perm true
```

Also install the [Azure Static Web Apps CLI](https://github.com/azure/static-web-apps-cli):

```sh
npm i -g @azure/static-web-apps-cli
```

## Test solution locally

Before starting the solution locally, you have to configure the Azure Function that is used to provide the backend API. In the `./api` folder create a `local.settings.json` file starting from the provided template. Also, if you want to run Azure Functions locally, for example to debug them, you also need a local Azure Storage emulator. You can use [Azurite](https://docs.microsoft.com/azure/storage/common/storage-use-azurite?tabs=visual-studio) that also has a VS Code extension.

```sh
swa start --app-location ./client --api-location ./api    
```

and you'll be good to go.

once this text will appear:

```sh
Azure Static Web Apps emulator started at http://localhost:4280. Press CTRL+C to exit.
```

everything will be up and running. Go the the indicated URL and you'll see the ToDo App. Go an play with it, it will work perfectly, having the Vue.js frontend calling the REST API provided by the Azure Function and storing the to-do list in a List object. 

## Deploy the solution on Azure

Now that you know everything works fine, you can deploy the solution to Azure. To make the deployment as easy as possible, the `azd` tool is used. Install it following the instructions here: [Install the Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)

Befor moving forward get an GitHub Token with the scopes `repo` and the `workflow`. Read here how to do it: [Create a GitHub Personal Access Token](https://learn.microsoft.com/azure/static-web-apps/publish-azure-resource-manager?tabs=azure-cli#create-a-github-personal-access-tokenn).

The GitHub Token is needed as Azure Static Web App will create a GitHub action in your repository in order to automate deployment of the solution to Azure. That is right: every time you'll push a code change to your code main code branch, the application will also be re-built and deployed in Azure.

Now initialize the deployment enviroment via

```
azd env get-values
```

Once the enviroment has been created, set the address of the GitHub repo to be used for deployment. Use the url of your forked repo:

```
azd env set GITHUB_REPO_URL https://github.com/<your_account>/azure-sql-db-fullstack-serverless-kickstart
```

and the set the GitHub access token you have created before:

```
azd env set GITHUB_REPO_TOKEN <github_token>
```

and then just run

```
azd up
```

from now own, you'll be able to just run the `up` command, as all other values are now set and will be reused (enviroment is stored in the `.azure` folder).

To clean up all the created resources, just use the `down` command:

```
azd down
```

## Run the solution on Azure

Once the deployment script has finished, you can go to the created Azure Static Web App in the Azure Portal and you can see it as been connected to the specified GitHub repository. Azure Static Web App has also created a new workflow in the GitHub repository that uses GitHub Actions to define the CI/CD pipeline that will build and publish the website every time a commit is pushed to the repo.

An example of the Azure Static Web App url you'll get is something like:

https://victorious-rock-01b2b501e.azurestaticapps.net/ 

The first time you'll visit the URL you might not see any to-do item, even if a couple are already inserted in the in-memory list as an example. This is due the fact that the Azure Function running behind the scenes can take several seconds to start up the first time.