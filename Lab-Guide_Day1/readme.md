# Introduction

The VMC with Tanzu Experience Day (VMCwithTanzu) workshop is an opportunity to test this unique combination of services that will help you to accelerate your app modernization. This workshop in based on a classroom model with VMware Cloud on AWS and Tanzu experts who support you during hands on lab exercises to understand and gain experience with these VMware Cloud services.

This Experience day is split into 2 sessions where we will discover VMware Cloud on AWS interface more generally and then have a look on the Lab prepared for you: what is the application, environment, and so on.

Once these environments have been covered we'll start hands-on section with workload migration into VMware Cloud on AWS, by leveraging its unique capabilities : live migration, no RE-IP with a still functioning application while migrating.
Once done, we will see how the front-end, migrated into the Cloud can still communicate with back-end VM still in the source environment.

Finally we will continue with the Modern app part of this workshop by activating and leveraging Tanzu, our Kubernetes service included into VMC to transform our current application based on VMs into containers. We will finally configure integration with AWS Services to see how easy it is to access to hundred of services to spice up your apps!

Enjoy!


# Lab Environment overview

2 different environments at your disposal both hosted on VMware Cloud on AWS, where first will act as the source datacenter, while the second will be the target where you will migrate workloads to modernize later the application.
![image](https://user-images.githubusercontent.com/12640326/150738653-57202d6d-4b0b-4586-84f4-8da22ec97dd1.png)

VMware Cloud on AWS has been leveraged for both environments, including source to act as an on-premise environment, please keep this in mind.

VMware team will provide all details about these environments (names, URLs, IP addresses...), please keep it or feel free to ask if not received.

Access to these SDDC's is done with Cloud Console URL: https://vmc.vmware.com 
You should have received an email invite to join these services after providing your email address to VMware team.

- Source SDDC name: "Source-SDDC"
- Target SDDC name: "Target-SDDC"

Example of Cloud console window with an SDDC:
![image](https://user-images.githubusercontent.com/12640326/150803063-8e7578c3-d7eb-4ace-91c3-009ea5662429.png)


All attendees will work in different groups (between 2 and 3 attendees per group), that VMware team will define and will communicate details about membership. Each group will work with a dedicated VM environment during labs, each folder will reflect group assignment following this order:
- Group01: front-end01 VM
- Group02: front-end02 VM
- Group03: front-end03 VM
- Group04: front-end04 VM
- Group05: front-end05 VM
- Group06: front-end06 VM
![image](https://user-images.githubusercontent.com/12640326/150803416-7b6ea8ab-369e-4d05-8c11-fea2cdc2ae12.png)


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
- Your public IP address: to get access to vCenter server as we don't want to publish it on the internet and want to avoid VPN for time constraints.


# Lab01: Access to Cloud Console and vCenter:

In order to achieve exercises, you need to first access to environment, so let's start with the Cloud Console:
Please, if not already connected to, open the Cloud console https://vmc.vmware.com and authenticate with your MyVMware account.
![image](https://user-images.githubusercontent.com/12640326/150806426-88c7c74a-6d8e-40d4-be20-04f2441f6c32.png)


Then click on "Source_SDDC" name to open its details, you see the SDDC main window that gives access to submenus with for example "networking & Security", "maintenance"...
![image](https://user-images.githubusercontent.com/12640326/150807071-73476b3e-2efb-4483-8fd1-6d5aad2131c1.png)


Since we don't want to publish vCenter interface to the internet and setting up a VPN would take time and we want to keep this workshop short and focused on workload migration and modernization we will secure connection by restristing access per public IP.
So, we will configure a firewall rule with NSX capabilites embedded into VMC by creating an inbound firewall rule giving access to vCenter from the different public IPs.

So, click on "networking & security" tab and then on the left panel, click on "Gateway firewall" as per screen below:
![image](https://user-images.githubusercontent.com/12640326/150808402-175ab117-0464-45e9-8d47-830e6c927249.png)



# Lab02: Know the application
The application used during this workshop is a 2-tier app composed of a front-end VM (NGINX with PHP) and a back-end VM (MariaDB).  

Each group of attendees has its own front-end VM (front-end01 to 06 VM) located into separated vCenter folder. The back-end VM is the same for all groups and will be shared among them.
![image](https://user-images.githubusercontent.com/12640326/150804235-4cb1dd2c-61e2-4171-9cdb-a650ef8cc109.png)


Browse within the source vCenter to discover these resources. For this you need to be authenticated to VMware Cloud Console and click on the "Source DC" name and then click on "open vCenter"  on the right top of the screen and use "username" 
![image](https://user-images.githubusercontent.com/12640326/150736425-ae23c76e-799f-4b60-a74f-0a54fdca8d3e.png)


# Lab03: Workload Migration

Now that you have introduced to VMware Cloud on AWS basic concepts, let's see how we can easily migrate a workload into this Cloud environment.
In this lab exercise you will learn about Hybrid Cloud Extension (HCX), this tool, bundled with VMware Cloud on AWS, will allow you to bulk migrate workloads to VMware Cloud on AWS and significantly reduce the time and complexity of moving workloads into the public Cloud environment.

VMware HCX abstracts on-premises and Cloud resources and presents them to the apps as one continuous hybrid cloud. HCX provides high-performance, secure and optimized multisite interconnects. The abstraction and interconnects create infrastructure hybridity. 

HCX has been installed to this environment to save time so you'll start directly with workload migration.

From the source datacenter (Source DC) available from the Cloud Console, click on 


# Lab03: Create firewall rule to access jumphost 



#Lab04: 
