# Introduction

The VMC with Tanzu Experience Day (VMCwithTanzu)workshop is an opportunity to test this unique combination of services that will help you to accelerate your app modernization. This workshop in based on a classroom model with VMware Cloud on AWS and Tanzu experts who support you during hands on lab exercises to understand and gain experience with these VMware Cloud services.

This Experience day is split into 2 sessions where we will discover VMware Cloud on AWS interface more generally and then have a look on the Lab prepared for you: what is the application, environment, and so on.

Once these environments have been covered we'll start hands-on section with workload migration into VMware Cloud on AWS, by leveraging its unique capabilities : live migration, no RE-IP with a still functioning application while migrating.
Once done, we will see how the front-end, migrated into the Cloud can still communicate with back-end VM still in the source environment.

Finally we will continue with the Modern app part of this workshop by activating and leveraging Tanzu, our Kubernetes service included into VMC to transform our current application based on VMs into containers. We will finally configure integration with AWS Services to see how easy it is to access to hundred of services to spice up your apps!

Enjoy!


# Lab Environment introduction

2 different environments at your disposal both hosted on VMware Cloud on AWS, where first will act as the source datacenter, while the second will be the target where you will migrate workloads to modernize later the application.
There's a jumphost VM hosted on target SDDC dedicated to internal tests or run some of the labs

Jumphost VM: 
- Name: grease-monkey
- IP Address: 
- Login:
- Password: 

VMware team will provide all details about these environments (names, URLs, IP addresses...), please keep it or feel free ask to ask if not received.

- Source SDDC name:
- Target SDDC name:
- Jumphost VM name:

All attendees will work in different groups (between 2 and 3 attendees per group), workshop, VMware team will define group and will communicate your membership. Each group will work with a dedicated VM environment during labs, each folder will reflect group assignment following this taxonomy:
- Group01
- Group02
- Group03
- Group04
- Group05
- Group06 

# Prerequisites:
- A computer of course :) with a browser (Google Chrome preferred) 
- SSH Client (ie: Putty)
- A MyVMware account is required to access VMware Cloud Console otherwise you'll be asked to create one, this is pretty simple and quick (email, first & last name). Once you provided your account email address you'll receive an email invitation to join an Organization called "Tanzu-VMC Exp Day", so please click on the link to join it and start labs.
-  


# Lab01: Know the application
The application used during this workshop is a 2 tier app composed of a front-end VM (NGINX with PHP) and a back-end VM (MariaDB)  


# Lab02: Workload Migration

Now that you have introduced to VMware Cloud on AWS basic concepts, let's see how we can easily migrate a workload into this Cloud environment.

From the source datacenter reachable from the Cloud Console, click on 


# Lab03: Create firewall rule to access jumphost 



#Lab04: 
