# Introduction

The VMC with Tanzu Experience Day (VMCwithTanzu) workshop is an opportunity to test this unique combination of services that will help you to accelerate your app modernization. This workshop in based on a classroom model with VMware Cloud on AWS and Tanzu experts who support you during hands on lab exercises to understand and gain experience with these VMware Cloud services.

This Experience day is split into 2 sessions where we will discover VMware Cloud on AWS interface more generally and then have a look on the Lab prepared for you: what is the application, environment, and so on.

Once these environments have been covered we'll start hands-on section with workload migration into VMware Cloud on AWS, by leveraging its unique capabilities : live migration, no RE-IP with a still functioning application while migrating.
Once done, we will see how the front-end, migrated into the Cloud can still communicate with back-end VM still in the source environment.

Finally we will continue with the Modern app part of this workshop by activating and leveraging Tanzu, our Kubernetes service included into VMC to transform our current application based on VMs into containers. We will finally configure integration with AWS Services to see how easy it is to access to hundred of services to spice up your apps!

Enjoy!


# Lab Environment introduction

2 different environments at your disposal both hosted on VMware Cloud on AWS, where first will act as the source datacenter, while the second will be the target where you will migrate workloads to modernize later the application.
![image](https://user-images.githubusercontent.com/12640326/150738653-57202d6d-4b0b-4586-84f4-8da22ec97dd1.png)


VMware team will provide all details about these environments (names, URLs, IP addresses...), please keep it or feel free to ask if not received.

- Source SDDC name: Source-SDDC
- Target SDDC name: Target-SDDC

All attendees will work in different groups (between 2 and 3 attendees per group), that VMware team will define and will communicate details about membership. Each group will work with a dedicated VM environment during labs, each folder will reflect group assignment following this order:
- Group01: front-end01 VM
- Group02: front-end02 VM
- Group03: front-end03 VM
- Group04: front-end04 VM
- Group05: front-end05 VM
- Group06: front-end06 VM

Finally, in the target SDDC, you will use a jump host VM called "grease-monkey" to achieve some exercises.
- Jumphost VM name: grease-monkey
- IP Address: 
- Login:
- Password: 


# Prerequisites:
- A computer of course :) with a browser (Google Chrome preferred) 
- SSH Client (ie: Putty)
- A Customer Connect previously known as "MyVMware" account is required to access VMware Cloud Console otherwise you'll be asked to create one, this is pretty simple and quick (email, first & last name). To do so, follow the link to Customer Connect portal : https://customerconnect.vmware.com/account-registration. 
Once you provided your account email address you'll receive an email invitation to join an Organization called "Tanzu-VMC Exp Day", so please click on the link to join it and start labs.


# Lab01: Know the application
The application used during this workshop is a 2-tier app composed of a front-end VM (NGINX with PHP) and a back-end VM (MariaDB).  

Each group of attendees has its own front-end VM (front-end01 to 06 VM) located into separated vCenter folder. The back-end VM is the same for all groups and will be shared among them.

Browse within the source vCenter to discover these resources. For this you need to be authenticated to VMware Cloud Console and click on the "Source DC" name and then click on "open vCenter"  on the right top of the screen and use "username" 
![image](https://user-images.githubusercontent.com/12640326/150736425-ae23c76e-799f-4b60-a74f-0a54fdca8d3e.png)


# Lab01: Workload Migration

Now that you have introduced to VMware Cloud on AWS basic concepts, let's see how we can easily migrate a workload into this Cloud environment.
In this lab exercise you will learn about Hybrid Cloud Extension (HCX), this tool, bundled with VMware Cloud on AWS, will allow you to bulk migrate workloads to VMware Cloud on AWS and significantly reduce the time and complexity of moving workloads into the public Cloud environment.

VMware HCX abstracts on-premises and Cloud resources and presents them to the apps as one continuous hybrid cloud. HCX provides high-performance, secure and optimized multisite interconnects. The abstraction and interconnects create infrastructure hybridity. 

HCX has been installed to this environment to save time so you'll start directly with workload migration.

From the source datacenter (Source DC) available from the Cloud Console, click on 


# Lab03: Create firewall rule to access jumphost 



#Lab04: 
