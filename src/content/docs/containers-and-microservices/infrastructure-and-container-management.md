[[toc]]

> Presented by Donovan Marais

#  Container vs VM 

Only the required files and infrastructure are required for a container, this allows us to have very fast environments and are a lot easier and smaller to set up than VM's

#  Cloud Automation Manager

**Service Automation, Orchestration and Multi-Cloud Management**

CAM is a tool in Cloud Private which will run on the client's hardware. With CAM I can orchestrate and manage VM's on any service and manage the data through my own firewall, but we can manage tasks like processing somewhere else

Above this we do not require environment and software licenses versus when using VM's

Application environments should be

* Easy to design and build
* Easy to govern and curate
* Simple to consume in a cloud independent way

We make use of Open Standards/Source technologies like **Terraform** to design and assemble our environments

Furthermore we are still able to use a GUI or Code in a declarative way to configure our environments

Automation enables us to enforce policies on our environments and integrate services and drive updates to our service databases \(CMDB's - Centralised Configuration Management Database\)

We can run a localised version of ICP for testing purposes

# # Template Designer

There are preexisting templates that we can use for our use cases with integrated code editing

We can maintain our infrastructure with code or with the GUI and manage config drift

From IBM Cloud Private we can deploy on Azure, Amazon, Google, etc. if we want to very easily by using drag-in docker containers and configurations

# # Service Composer

* Visually bind service orchestrations
* Build services with Helm and Terraform
  * Mixed Cloud
  * Mixed Architecture
* Integrate with Adjacent Services
  * CMDB's / REST
  * Custom Integration

#  Demo

[Automation Manager Demo on BlueDemos](https://bluedemos.com/show/765)

