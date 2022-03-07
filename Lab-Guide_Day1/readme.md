# Introduction

The VMC with Tanzu Experience Day (VMCwithTanzu) workshop is an opportunity to test this unique combination of services that will help you to accelerate your app modernization. This workshop in based on a classroom model with VMware Cloud on AWS and Tanzu experts who support you during hands on lab exercises to understand and gain experience with these VMware Cloud services.

This Experience day is split into 2 sessions where we will discover VMware Cloud on AWS interface more generally and then have a look on the Lab prepared for you: what is the application, environment, and so on.

Once these environments have been covered we'll start hands-on section with workload migration into VMware Cloud on AWS, by leveraging its unique capabilities : live migration, no RE-IP with a still functioning application while migrating.
Once done, we will see how the front-end, migrated into the Cloud can still communicate with back-end VM still in the source environment.

Finally we will continue with the Modern app part of this workshop by activating and leveraging Tanzu, our Kubernetes service included into VMC to transform our current application based on VMs into containers. We will finally configure integration with AWS Services to see how easy it is to access to hundred of services to spice up your apps!

Enjoy!


# Lab Environment overview

2 different environments at your disposal both hosted on VMware Cloud on AWS, where first will act as the source datacenter, while the second will be the target where you will migrate workloads to modernize later the application.

![lab-environment](../img/lab.png)

VMware Cloud on AWS has been leveraged for both environments, including source to act as an on-premise environment, please keep this in mind.

VMware team will provide all details about these environments (names, URLs, IP addresses...), please keep it or feel free to ask if not received.

Access to these SDDC's is done with Cloud Console URL: https://vmc.vmware.com 
You should have received an email invite to join these services after providing your email address to VMware team.

- Source SDDC name: "Source_SDDC"
- Target SDDC name: "Destination_SDDC"

Example of Cloud console window with an SDDC:
![image](https://user-images.githubusercontent.com/12640326/150803063-8e7578c3-d7eb-4ace-91c3-009ea5662429.png)


All attendees will work in different groups (between 2 and 3 attendees per group), that VMware team will define and will communicate details about membership. Each group will work with a dedicated VM environment during labs, each folder will reflect group assignment following this order:
- Room01: frontend-room01 VM
- Room02: frontend-room02 VM
- Room03: frontend-room03 VM
- Room04: frontend-room04 VM
- Room05: frontend-room05 VM
- Room06: frontend-room06 VM

![VM Folders](../img/vms-folders.png)


You will use a jump host VM called "grease-monkey" to achieve some day2 exercises.


# Prerequisites:
- A computer of course :) with a browser 
- A Customer Connect previously known as "MyVMware" account is required to access VMware Cloud Console otherwise you'll be asked to create one, this is pretty simple and quick (email, first & last name). To do so, follow the link to Customer Connect portal : https://customerconnect.vmware.com/account-registration. 
Once you provided your account email address you'll receive an email invitation to join an Organization called "Tanzu-VMC Exp Day", so please click on the link to join it and start labs.

# Connect to LAB Environment
In order to easily access the resources deployed in the VMC lab we will use VMware Horizon technology to access remote desktops with the necessary tools and configurations.
You can point your browser to the following URL https://horizon.semealab.cloud where a welcome screen will appear as shown below:

![vdi-landingpage](../img/vdi1.png)

Select "VMware Horizon HTML Access" at the bottom right of the welcome screen. This will load the web client version of VMware Horizon.
When the loading process is complete we will be prompted to enter our login credentials (which will be provided by the speaker) and proceed to click on the "Login" button.

![vdi-login](../img/vdi2.png)

Once authenticated, you can access you desktop by clicking on the "Windows10" orange cloud icon.

![vdi-desktop](../img/vdi3.png)


# Lab01: Access to Cloud Console and vCenter:

In order to achieve exercises, you need to first access to environment, so let's start with the Cloud Console:
Please, if not already connected to, open the Cloud console https://vmc.vmware.com and authenticate with your MyVMware account.

![lab-environment](../img/lab01a.png)


Then click on "Source_SDDC" name to open its details, you see the SDDC main window that gives access to submenus with for example "networking & Security", "maintenance"...

![image](https://user-images.githubusercontent.com/12640326/150807071-73476b3e-2efb-4483-8fd1-6d5aad2131c1.png)


We can define Firewall Rules in order to protect our workloads access.
For example, we did not publish the vCenter to be accessed from any address in the internet, but restricted connections just from the administrators' addresses.
So, we configured a firewall rule with NSX capabilities embedded into VMC by creating the required objects.

You can click on "networking & security" tab and then on the left panel, click on "Gateway firewall" as per screen below. You will find the vCenter incoming traffic rule in the "Management Gateway" section:

![image](https://user-images.githubusercontent.com/12640326/150808402-175ab117-0464-45e9-8d47-830e6c927249.png)


# Lab02: Workload Migration

Now that you have introduced to VMware Cloud on AWS basic concepts, let's see how we can easily migrate a workload into this Cloud environment.
In this lab exercise you will learn about Hybrid Cloud Extension (HCX), this tool, bundled with VMware Cloud on AWS, will allow you to bulk migrate workloads to VMware Cloud on AWS and significantly reduce the time and complexity of moving workloads into the public Cloud environment.

VMware HCX abstracts on-premises and Cloud resources and presents them to the apps as one continuous hybrid cloud. HCX provides high-performance, secure and optimized multisite interconnects. The abstraction and interconnects create infrastructure hybridity. 

HCX has been installed to this environment to save time so you'll start directly with workload migration.

The application used during this workshop is a 2-tier app composed of a front-end VM (NGINX with PHP) and a back-end VM (MariaDB).  

Each group of attendees has its own front-end VM (front-end01 to 06 VM) located into separated vCenter folder. The back-end VM is the same for all groups and will be shared among them.

![image](https://user-images.githubusercontent.com/70263743/157101655-8ba42efb-f682-43fa-a0bc-2978550b2115.png)

Now let's start by accessing HCX on the source datacenter.
Access HCX plug-in from your vSphere Client

![acme-in-kube](../img/hcx-plugin.png)

or directly via HCX Client: https://hcx.sddc-15-188-191-254.vmwarevmc.com/ with provided credentials.

You should see this dashboard:
![image](https://user-images.githubusercontent.com/12640326/150930491-d1d821f3-bc6a-49f3-b23d-f50d1aebe337.png)

You can see HCX details, location of datacenters, statistics about migrated VMs, etc...

Now, let's got to the "migrate" menu on the left to select VM to migrate:

![image](https://user-images.githubusercontent.com/12640326/150931010-4e1ef533-9040-4d3c-a903-d0d04419d61f.png)

Once in the "migrate" menu, please open the "migrate window' by clicking on the button in the middle, a new pop-up window appears:

![image](https://user-images.githubusercontent.com/12640326/150932204-1a0d5421-cd1f-4df7-aa51-038d76856deb.png)

Once inventory is loaded, you can see on the left the vCenter folder structure and when you click on workloads folder you will see all VMs from each group. Please select your assigned folder (Group01 = Room01, etc..) and please select the appropriate front-end VM.
![image](https://user-images.githubusercontent.com/12640326/150932453-1531455d-06a7-4a36-b52a-0e9e8dda110c.png)


Then, once, you've selected your VM, proceed now with the target options, as you need to indicate where your Virtual machine wil be located at folder, resource pool/compute and storage level.
So, select these criteria among the following menus as screen indicates:
- 1) Resource Pool = ComputeResourcePool
- 2) Datastore = WorkloadDatastore
- 3) Migration mode = vMotion
Note that if you select wrong resource pool or datastore you will have an error message as these resources are reserved for VMware Cloud on AWS management virtual machines (vCenter, NSX...)

Let the other options like "Switchover" and "Extended options" as default.

![image](https://user-images.githubusercontent.com/12640326/150969268-e55966d9-5d2b-4e2b-a73c-2cc206c49756.png)


Once you finished with the options, click on "add" to include VM into migration wave, then ckick on "validate"to check if no issues are identified and once validation is approved with a green mark, you can click on "go" and let the process running: (about 10 minutes) 
![image](https://user-images.githubusercontent.com/12640326/150933057-e8183680-99d8-4907-9e64-96bb1d39cb63.png)


You can see progress and expand menus to get extended details: steps, timer, as per screen below
![image](https://user-images.githubusercontent.com/12640326/150933284-9795c659-e733-4586-9fd6-b73509004762.png)


You can also check into your target vCenter, available from the Cloud Console, in the "Destination_SDDC" that your VM is now into the inventory.

Congratulations, your VM has been migrated !!


