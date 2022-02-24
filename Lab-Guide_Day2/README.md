# Lab Guide Day 2

To discover even further Tanzu, visit [Tanzu Know It all](https://github.com/bdereims/tkia) git repo.<br>
[Cloud-Garage Blog](https://blog.cloud-garage.net/) is also good content about hybrid-cloud and gitops.<br>

# Introduction
This second part of this workshop is dedicated to the App Modernization topics and relies mainly on VMware Tanzu, our container management solution which is now also available on VMware Cloud on AWS as you will see during labs.

You will use user `roomXX` / `roomXX` (XX is an integer, such as 01 or 02) on jumpbox called grease-monkey. One user per group, suggested app has been extracted and based on one running on previous front-end VM. So, the main purpose is to run 2 distinct pods instead of a VM: nginx + phpfpm. The intend to do that is to leverage k8s capabilities to easily scale application depending on number of request.


![acme-in-kube](../img/acme-in-pods.png)

# Connect to LAB Environment
In order to easily access the resources deployed in the VMC lab we will use VMware Horizon technology to access remote desktops with the necessary tools and configurations.
You can point your browser to the following URL https://horizon.semealab.cloud where a welcome screen will appear as shown below:

![vdi-landingpage](../img/vdi1.png)

Select "VMware Horizon HTML Access" at the bottom right of the welcome screen. This will load the web client version of VMware Horizon.
When the loading process is complete we will be prompted to enter our login credentials (which will be provided by the speaker) and proceed to click on the "Login" button.

![vdi-login](../img/vdi2.png)

Once authenticated, you can access you desktop by clicking on the "Windows10" orange cloud icon.

![vdi-desktop](../img/vdi3.png)

# Lab200: VMC + Tanzu
We have initiated TKG deployment in this VMC instance, roughly similar to on-premise installation.
Navigate through UI, discover how Tanzu manage K8S Workload Cluster: supervisor cluster namespaces, how to limit CPU/Memory/Storage per namespace & Cloud Native Storage. 
Tanzu offer SSO between VCSA and Kubernetes.


Worload Management Menu in VCSA:<br>
![Workload Management in VCSA](../img/WorkloadManagement.png)


Supervisor Namespace Management:
![namespace](../img/namespace.png)


Cloud Native Storage in VCSA:
![CNS](../img/CNS.png)


# Lab201: Discovery and setup
Log into the Grease-Monkey jumpbox. Open a command-line prompt and run the following command: `ssh roomXX@grease-monkey-vmc.cloud-garage.net`. The password is the same for the VDI.
Clone the git repo in home: `git clone https://github.com/thecatpower/VMCwithHCX-Tanzu.git`
Take time to discover directory structure, specifically `~/VMCwithHCX-Tanzu/Lab-Guide_Day2` and `~/VMCwithHCX-Tanzu/Tanzu` dirs.

test it in running local nginx container on grease-monkey and access it:
`docker run -d -p $(expr $( ech: ${USER} | sed "s/room//") + 8080):80 --name=${USER} nginx`
You should able to visit http://grease-monkey:[your_port_number]

As a DevSecOps team member you have access to source code of the app. Go to `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs` directory.
If you are brave enough, you can modify some artefacts like: `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/containers/html/index.html`  
If you get lost or confused, reclone repo in order to start from scratch

It's time to build application.

# Lab202: Create registry project
Sign up with your creds `roomX` / `roomX` to [VMware Harbor](https://registry.cloud-garage.net).

![harbor-1](../img/harbor-1.png)

![harbor-2](../img/harbor-2.png)

Log into and create project with name of your user, __don't forget to set it public__.

![harbor-3](../img/harbor-3.png)

![harbor-4](../img/harbor-4.png)

# Lab203: Build the app
Go to ~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs directory.
Now, were going to build app containers. This command will build the two Docker images: acme-nginx and acme-php-fpm.
Move into the `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/containers` and inspect the content of the two folders: nginx and php-fpm.
Inside the two folders you'll find a Dockerfile, which defines the entire Docker image:

`cat ~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/containers/nginx/Dockerfile`

![lab203-1](../img/lab203-1.png)

Now, run the `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/build.sh` command. This command will run all the steps defined in the Dockerfile to build the acme-nginx and acme-php-fpm images:

![lab203-2](../img/lab203-2.png)

Inspect your freshly created container images: `docker images`.

![lab203-3](../img/lab203-3.png)

# Lab204: Push container images to registry
Log yourself to registry: `docker login registry.cloud-garage.net`. The username is roomXX and the password is the same as the VDI.

![lab204-1](../img/lab204-1.png)

You can upload the images to the registry by running the script: `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/push.sh`. You are invited to discover `containers/Makefile`.

![lab204-2](../img/lab204-2.png)

Inspect the result into Harbor:

![lab204-3](../img/lab204-3.png)

Launch a vulnerability scan against the freshly pushed images by clicking the name of each of them, selecting it and clicking on Scan:

![lab204-4](../img/lab204-4.png)

![lab204-5](../img/lab204-5.png)

![lab204-6](../img/lab204-6.png)


Modify your project to automaticaly scan any new pushed images and avoid deploying ones low and higher vulnerability severities.

Go to the project view and click on Configuration

![lab204-7](../img/lab204-7.png)

Select "Prevent vulnerable images from running". 
Select "High" as a vulnerability threshold
Select Automatically scan images on push

![lab204-8](../img/lab204-8.png)


# Lab205: Deploy application
With the help of `./deploy.sh`, app is now running in namespace of your name.
Inspect deployment with: `kubectl -n ${USER} get pods,svc`.
What do you conclude? Does it match with your exspectations?

Inspect furthermore with: `kubectl -n ${USER} get networkpolicies,hpa`.

Try to access app from your favorite browser. Does it work?

Try to run busybox pod in your namespace and reach php page: `kubectl -n ${USER} run -it --rm busybox --image=busybox -- sh` and ``
What is the result? Why?

Load the app and discover how k8s scale deployments: `./scale_in_pods.sh`.

Tips: there is a namespace that's running Octant.


# Lab206: Tanzu Management 
Tanzu offer a flexible way to manage k8s cluster, scale out/in clusters is an exmaple. Because k8s clusters are operated by k8s, all is yaml.
Go to `~/VMCwithHCX-Tanzu/Tanzu/tkgs/guest-cluster` dir and discover how we deploy cluster with `create-managed-cluster.yaml`.
What do you notice in this yaml?

t's needed to be login into suprervisor cluster and workload cluster, there are scripts for that in `~/VMCwithHCX-Tanzu/Tanzu`: `./login.sh` and `login-guest-cluster.sh`.

It's possible to directly manage cluster with `tanzukubernetesclusters.run.tanzu.vmware.com` object: `kubectl get tkc -A`.
In place k8s release upgrade is possible. To do that, edit tkc item and change version accordingly to what Tanzu offer, for example: `kubectl -n tkgs edit tkc acme` and replace version.

!!! Don't modify relrease right now !!! 

VMware also provide open source solution to manage kube's objects: [Octant](https://github.com/vmware-tanzu/octant). Octant is able to run on your laptop, in container or as a deployment in kubernetes.
Open a new tab in your browser and visit [Octant UI](http://octant.vmc-tanzu.io). Discover objects depending of deployed app in your namespace, try to interact within terminal console for nginx pods 

Octant, a Kube Dashboard on steroid:<br>
![Octant](../img/octant.png)

# Lab207: Tanzu Monitoring
Tanzu offer prometheus/grafana to monitor k8s cluster and apps. There is also Tanzu Observability, SaaS solution offering monitoring/distributed tracing/correlated events.
Let's give a shot to Grafana, open a new tab in browser with: [Grafana console](http://grafana.vmc-tanzu.io:3000).
Use admin user with provided password in order to log on. Navigate to Dashboard -> Browse -> TKG Kubernetes cluster monitoring.
Data have been scapped by prometeus and presented into dashboard by grafana. Tanzu Observability uses also PromQL language to create abstracted values like prometheus, you have the choice.

Promotheus/Grafana monitoring kube cluster and apps:<br>
![Grafana](../img/grafana.png)

# Lab208(optional): Switching back-end VM to AWS native services
The goal is to replace VM database by RDS instance in aws.
So, create your own RDS instance. Export/Import mariadb schema in RDS. Modify env file to point to RDS instance. Rebuild/repush/redeploy app or modify your existing running app.
Is a big deal to use managed service in aws? what's about performance and lifecycle management? What's about the cost?

All script regarding DB in localized in: `~/VMCwithHCX-Tanzu/Tanzu/VMs2PODs/dbtools`  
