
# GCP Starter-kit Template
This is a bare-bones template project for generating GCP CI/CD and Terraform manifests (Helm files, Spinnaker JSON, Cloudbuild.yaml, Terraform files for CloudBuild trigger) with project specific information. This is intended to be a framework/language agnostic template. 
This template repo also allows the _optional_ generation of:
* **NodeJS** example source code, package.json and a Docker file for a "Hello World" application
* **Java** example srouce code, pom.xml and a Docker file for a "Hello World" application
* **Python** example source code, requirements.txt, and a Docker file for a "Hello World" application

In addition to the basic "Hello World" template application, the following GCP Service implementation samples are provided:  
![cloudsql](https://user-images.githubusercontent.com/83463333/127359952-0c7f7a6b-bae4-4b4d-af10-b955862cafd3.png)
**CloudSQL for PostGreSQL DB**   
This sample implements access to the GCP CloudSQL for PostgreSQL through SQL Proxy from GKE deployment. 

![memorystore](https://user-images.githubusercontent.com/83463333/127360341-6e269f3b-1826-4292-bfb6-ff941d04f339.png)
**Cloud Memorystore for Redis**  
This sample implements access to the GCP Memorystore for Redis from GKE deployment.

![storage](https://user-images.githubusercontent.com/83463333/127360568-15c8540e-52de-48d7-bc6d-58e5875f569a.png)
**Cloud Storage**  
This sample implements access to the GCP Storage from GKE deployment.

![firestore](https://user-images.githubusercontent.com/83463333/127360925-332b673f-0c6a-4c60-b43b-fb4fd2fa30e4.png)
**Cloud Firestore**  
Coming soon.

![pubsub](https://user-images.githubusercontent.com/83463333/127361001-0fc8924f-854c-4b3b-b641-85265f191535.png)
**Cloud Pub/Sub**  
Coming soon.

# Before you begin  
Before you begin using this template, the following prerequisites must be met for each type of GCP service implementation:

**General Requirements:** GCP Project, GCP Namespace and Spinanker Service Account should already be acquired from TELUS CCoE.  
**CloudSQL:** CloudSQL API, CloudSQL Instance, Google Service Account (GSA), Kubernetes Service Account (KSA)  
**Memorystore:** Cloud Memorystore for Redis API  
**Cloud Storage:** Cloud Storage API  

# Setup

### Create a repository from this template

1. Click the big green button `Use this template` or click <a href="../../generate">here</a>.
2. Enter a Repository name and click `Create repository from template`. _Tip: Use Telus/ as repository owner._
3. Head over to the created repository and complete the setup.

### Complete setup
For each type of GCP service implementation, a corresponding `cookiecutter-xxxx.json` file has been provided.   
**Important:** A GitHub Action will kick in as soon as the first commit is done to generate the manifests. So the **fully populated** `cookiecutter-xxxx.json` **should be the first commit**

#### cookiecutter.json
The following general attributes defined in this file is used to generate all the manifests

##### General Attributes (Mandatory)

Attribute | Description
------------ | -------------
name | Name of the Project/Application. This really only affects the readme file
chart | HELM Chart Version#
application | Name of the application. Can be the same as name. Spinnaker pipelines and GKE Deployments will contain this name
namespace | GKE Namespace. _Provided by CCoE_
clusterNp | GKE Non Production Cluster. _Provided by CCoE_
clusterPr | GKE Production Cluster. _Provided by CCoE_
cmdbId | CMDB ID
costCentre | TELUS Cost Centre
organization | Usually "CIO"
mailingList | Any notifications will be sent here
spinnakerServiceAccount | Spinnaker Service Account. _Provided by CCoE_
port | The PORT that will be exposed via a service
gcpProjectIdNp | Non Production GCP Project ID. _Provided by CCoE_
gcpProjectIdPr | Production GCP Project ID. _Provided by CCoE_
gsa | GCP Service Account, created via terraform
ksa | Kubernetes Service Account, created via terraform
dnsRequest | 'private' or 'public' to create a dns request yaml file. Leav empty for no dns request. follow instructions [here](https://developers.telus.com/guides/authenticating-users-in-an-end-user-facing-application?single-page=true) to submit your dns request"
**programmingLanguage** | **Possible values: 'nodejs', 'java', or 'python'**
sonarSourcesDir | Path within your repo to your source code for Sonarqube analysissonarSourcesDir

#### Basic Hello World Application Setup
1. In the new repository, <a href="../../edit/main/cookiecutter.json">complete the project setup</a> by editing the `cookiecutter.json` file. 
2. Add the desired source code folder, a Docker file and update the files under `/helm` directory as required
3. (Optional) Update files under `/helm` directory. The following parameters may required to be changed depending on your Docker file and source code: `command`, `commandArgs`, `livenessProbe` and `readinessProbe`  
##### Expected Output
The following files should be generated with the parameters provided in `cookiecutter.json` file
1. `cloubuild.yaml`
2. Helm files under `/helm` directory
3. A file containing Spinnaker Pipeline JSON data under `/spinnaker` directory. This can be copied over to Spinnaker to create a new pipeline
4. Terraform files under `/terraform` directory

# _NOTE_  
After the first commit of the cookiecutter-xxxx.json file, the corresponding Terraform scripts will be available in the `/Terraform` folder of your new repository. The Terraform scripts is formatted based on the inputs you provided in the related cookiecutter-xxxx.json file.  
It is important to copy the terraform files to your project's `tf-infra-` repository that has been created by CCoE. Follow the instructions provided within the email you receive from CCoE after the project was provisioned. 

### I have a repository and some source code. Now what?
1. Create a GCP CloudBuild trigger and Spinnaker pipeline for your repository. Follow the instructions [here](https://developers.telus.com/guides/manual-gcp-pipeline-setup?single-page=true)
2. Run a CloudBuild and if everything was set up correctly, your Spinnaker pipeline should deploy to the GKE Cluster and GKE Namespace you put in the `cookiecutter.json` file.

### CloudSQL Attributes  
#### ([cookiecutter-psql.json](../../edit/main/cookiecutter-psql.json))
Attribute | Description
------------ | -------------
cloudsqlConnNameNp | Non Production Connection name as seen in the GCP CloudSQL Console. [More Info](https://cloud.google.com/sql/docs/postgres/instance-info#connect_to_this_instance)
cloudsqlConnNamePr | Production Connection name as seen in the GCP CloudSQL Console

### Cloud Memorystore Attributes  
#### ([cookiecutter-memstore.json](../../edit/main/cookiecutter-memstore.json))
Attribute | Description
------------ | -------------
githubRepo | Name of **this** repository (without the "/telus/")
redisIP | IP Address for the Redis Instance created in GCP Memorystore. 
redisPort | Redis Port. The defaul tvalue is: "6379"


_Note_: If you already have an existing Redis instance to connect to, enter the IP address here.  You can obtain your Redis instance's IP address by navigating to your project's GCP Console, select Memorystore -> Redis.  
If you don't have an existing Redis instance, your Redis instance will be created once you copy the generated terraform file `memstore.tf` to your project's `tf-infra-` repository.  
Once the Redis instance is created, you need to update the generated `helm` chart files in the `/helm` folder of your repository to enter the IP address of your Redis instance.  

### Cloud Storage Attributes  
#### ([cookiecutter-gcstorage.json](../../edit/main/cookiecutter-gcstorage.json))
Attribute | Description
------------ | -------------
storageBucket | The name of your storage bucket to be created.


### PubSub Attributes  
#### ([cookiecutter-pubsub.json](../../edit/main/cookiecutter-pubsub.json))
Attribute | Description
------------ | -------------
topic | The name of your pubsub topic to be created. (_Default: "sample-topic-1"_)   
subscription | The name of your subscription to be created. (_Default: "sample-subscription-1"_)
