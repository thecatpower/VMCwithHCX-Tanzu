# Lab Guide Day 2

# Introduction
This second part of this workshop is dedicated to the App Modernization topics and relies mainly on VMware Tanzu, our container management solution which is now also available on VMware Cloud on AWS as you will see during labs.

You will use user `roomX` / `roomX` (X is an integer) on jumpbox call grease-monkey. One user per group, suggested app has been extracted and based on one running on previous front-end VM. So, the main purpose
is to run 2 distinct pods instead of a VM: nginx + phpfm. The intend to do that is to leverage k8s capabilities to easyly scale application depending on number of request.


![acme-in-kube](../img/acme-in-pods.png)


# Lab201: Discovery and setup
Get you familliar with jumpbox with proxy socks, use ssh or ptty: `ssh -D 9090 roomX@grease-monkey-vmc.cloud-garage.net`
Clone the git repo in home: `git clone https://github.com/cdebosc/VMCwithHCX-Tanzu.git`
Take time to discover directory structure, specificaly `~/VMCwithHCX-Tanzu/Lab-Guide_Day2` and `~/VMCwithHCX-Tanzu/Tanzu` dirs.

Setup your favorite browser to use local proxy socks: settings -> advanced -> system -> open your computer's proxy settings -> select socks with localhost:9090

test it in running local nginx container on grease-monkey and access it:
`docker run -d -p $(expr $( ech: ${USER} | sed "s/room//") + 8080):80 --name=${USER} nginx`
You should able to visit http://grease-monkey:[your port number]

As a DevSecOps team member you have access to source code of the app. Go to `~/VMCwithHCX-Tanzu/Tanzu/VMs2POD` directory.
If you are brave enough, you can modify some artefacts like: `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/containers/html/index.html`  
If you get lost or confused, reclone repo in order to start from scratch

It's time to build application.

# Lab202: Create registry project
Sign up with your creds `roomX` / `roomX` to [VMware Harbor](https://registry.cloud-garage.net).
Log into and create a project with the name of your user, don't forget to set it public.

# Lab203: Build the app
Go to `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs` directory and inspect/modify `env` file specifying all settings.
Now, we will build app containers with the help of `./build.sh`.
Inspect your fresh container images: `docker images`.

# Lab204: Push container images to registry
Log yourself to registry: `docker login registry.cloud-garage.net`, your creds are quite obvious.
Push to reg with: `./push.sh`.
Inspect the result into Harbor. Launch a vulnerability scan against freshly pushed images, what is the result?
Modify your project to automaticaly scan any new pushed images and avoid to deploy ones low and higher vulnerability severities.

# Lab205: Deploy application
With the help of `./deploy.sh`, app is now running in namespace of your name.
Inspect deployment with: `kubectl -n ${USER} get pods,svc`.
What do you conclude? Does it match with your exspectations?

Inspect furthermore with: `kubectl -n ${USER} get networkpolicies,hpa`.

Try to access app from your favorite browser. Does it work?

Load the app and discover how k8s scale deployments: `./scale_test.sh`.

Tips: there is a namespace that's running Octant.


# Lab XX: Tanzu Management 


# Lab XX: Tanzu Monitoring


# Lab XX: Switching back-end VM to AWS native services
