# Atlas-Of-Thrones - Bran the Less Broken Edition

## Changes made
* Complete service topology in Kubernetes - (see directory `k8s/`)
* Separate directories, images and services for `api` and `frontend`
* Simple deployment and iteration locally and in the cloud using `Skaffold`: https://github.com/GoogleContainerTools/skaffold
    * Hot code reloading without rebuilding Docker images using webpack + Skaffold file sync

## Local Environment Setup
This was tested extensively using Docker for Mac but should in theory work with other local Kubernetes environments such as `minikube` or `microk8s` on either macOS or Linux.

Download Docker for Mac here if you don't already have it: https://docs.docker.com/v17.12/docker-for-mac/install/

Make sure to enable Kubernetes once installed: https://docs.docker.com/docker-for-mac/#kubernetes

While Kubernetes is booting, download and install Skaffold: https://skaffold.dev/docs/getting-started/#installing-skaffold
Skaffold can also be install with Homebrew on macOS: 

`$ brew update && brew install skaffold`

Clone this repository if you haven't already: 

`$ git clone git@github.com:addisonbair/Atlas-Of-Thrones.git && cd Atlas-Of-Thrones`

Once Kubernetes is ready and Skaffold is installed, make sure your Kubernetes context points to the local cluster: 

`$ kubectl config use-context docker-for-desktop`

## Build and deploy the app
`$ skaffold dev`

This transparently builds, tags, templates and applies the Kubernetes resources to the local cluster while also streaming logs from all services.

It can take a couple minutes to build docker images the first time, but subsequent builds should be very quick.

Once everything is built and running, you should be able to navigate to `localhost:8080` and strike `localhost:5000/kingdoms` (for example)

Try out the hot code reloading on the frontend by editing any file in `frontend/app/` and watch each frontend replica automatically rebuild `bundle.js` with webpack. You will probably need to perform a hard refresh of your browser to see results of your changes.

Once you're done poking around with the local environment, `Ctrl + C` will end the log stream and clean up all the deployed resources.

If you want a permanent deployment, run:

`$ skaffold run`

And finally tear down the resources with:

`$ skaffold delete`

## Build and deploy the app on Azure Kubernetes Service
Install the Azure CLI tools if you haven't already: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

You can install them easily with Homebrew on macOS:

`$ brew update && brew install azure-cli`

Then login using your email:

`$ az login`

Setup access to AKS and ACR with the following:

`$ az aks get-credentials -g aothrones -n aothrones && az acr login -n aothrones`

If this doesn't work for some reason, please contact me. You shouldn't have any issues however.

Your Kubernetes context should be set to the AKS cluster named `aothrones`, but just to make sure run:

`$ kubectl config use-context aothrones`

Now run the same command that we did locally.

`$ skaffold dev`

You'll notice that Skaffold is performing the exact same workflow as it did locally, only now it is using a remote container image registry as well as deploying containers and streaming logs from the cloud. It may take substantially longer for a full deploy as disk provisioning for the StatefulSets can be pretty slow on Azure.

Once all the services are up, you'll notice that browsing to `localhost:8080` doesn't conveniently work. However we can remedy this by running the following in a new terminal window while `$ skaffold dev` is still streaming:

`$ (kubectl port-forward svc/api 5000:5000 & kubectl port-forward svc/frontend 8080:8080)`

Kubernetes allows for port forwarding to be established over an SSL tunnel.

Now you should be able to browse `localhost:8080` in your browser and curl `localhost:5000/kingdoms` just as if the service were running locally. For a real-world solution, you'd use an Ingress controller which can terminate SSL and manage public DNS records for a friendly URL.

Also, for a cool trick, try out the hot code reloading against the AKS cluster.

One small limitation of this solution is that it is not multi-tenant. Please be courteous to the next user and tear down your app on AKS by running `$ skaffold delete` if you ran a previous `$ skaffold run`. It is possible to template namespaces using Helm + Skaffold for each developer to have access to a cloud-based dev environment if necessary.

## Closing thoughts
I really enjoyed this mini project and greatly appreciated the Game of Thrones theme! 

I deliberately chose to focus my efforts around devUX and decoupling the api and frontend runtimes while keeping the codebase otherwise intact. Introducing Kubernetes was also deliberate as it allowed for a single deployment manifest to be used both locally and remotely with the same tooling. I've set up a much more robust version of this for Remesh and developers found it very useful.

There's obviously a lot more to work surrounding testing, telemetry, security and automation, but I hope this gives you a reasonable approximation of how I might approach an open-ended problem with some clear deliverables.

I'd love to get your feedback about this solution and hope all goes well with it. If there are any questions or anything else I can share, please don't hesitate to reach out to me. Thanks so much!

-------------------------------
## Original Readme

An interactive "Game of Thrones" map powered by Leaflet, PostGIS, and Redis.

Visit https://atlasofthrones.com/ to explore the application.

Visit http://blog.patricktriest.com/game-of-thrones-map-node-postgres-redis/ for a tutorial on building the backend, using Node.js, PostGIS, and Redis.

Visit https://blog.patricktriest.com/game-of-thrones-leaflet-webpack/ for part II of the tutorial, which provides a detailed guide to building the frontend webapp using Webpack, Leaflet, and framework-less Javascript components.

![](https://cdn.patricktriest.com/blog/images/posts/got_map/got_map.jpg)

#### Structure
- `app/` - The front-end web application source.
- `public/` - The compiled and minified front-end code.
- `server/` - The Node.js API server code.
- `data_augmentation/` - A collection of scripts to augment the shapefile data with summary data scraped from various wikis.
- `geojson_preview` - A simple html page to preview geojson data on a map.

#### Setup

To setup the project, simply download or clone the project to your local machine and `npm install`.

You can find a SQL database dump here with all of the content pre-loaded and ready to be queried - https://cdn.patricktriest.com/atlas-of-thrones/atlas_of_thrones.sql

The only extra step is adding a `.env` file in order to properly initialize the required environment variables.

Here's an example `.env` file with sensible defaults for local development -
```
PORT=5000
DATABASE_URL=postgres://patrick@localhost:5432/atlas_of_thrones?ssl=false
REDIS_HOST=localhost
REDIS_PORT=6379
CORS_ORIGIN=http://localhost:8080
```

You'll need to change the username in the DATABASE_URL entry to match your PostgreSQL user credentials. Unless your name is "Patrick", that is, in which case it might already be fine.

Run `npm run dev` to start the API server on `localhost:5000`, and to build/watch/serve the frontend code from `localhost:8080`.

___


This app is 100% open-source, feel free to utilize the code however you would like.

```
The MIT License (MIT)

Copyright (c) 2018 Patrick Triest

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
