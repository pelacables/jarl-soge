# soge

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with soge](#setup)
    * [What soge affects](#what-soge-affects)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Puppet module that installs and configures SoGE in a submit or execution host.
(It can probably install any *GE).
Tested in SL7 and Puppet 5.

*I did not want to update the UGE module cause I don't have any UGE instance right now and I could not test it.

## Setup

### What soge affects 

The module installs SoGE package from **your local repository**.
It accepts two different nodes: execution/submit.
It can also configures soge_execd service (only in a execution host), adds
sgeadmin user and sge_request (if defined) in the submission host.

### Setup Requirements 

The gridengine rpm packages have to be available in the system (already installed or available in a yum repository).
*you can use https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/*
*but it is not a valid yum repository*

## Usage

```puppet
class { 'soge' :
  manage_user    => true,
  manage_service => true,
}
```

Or if you use hiera:

```puppet
 classes:
   - '::soge'
 soge::soge_cell: 'jarl'
 soge::soge_cluster_name: 'condemor'
 soge::soge_qmaster_port: '7454'
 soge::manage_user: true
 soge::sge_request:
  - '-w w'
  - '-q short'
  - '-l h_vmem=4G,h_rt=6:00:00'
  - '-v _JAVA_OPTIONS=-Xmx3276M'
```


## Reference

### Classes

#### Public Classes

* soge: Main class, includes all other classes.

#### Private Classes

* soge::install: Installs SoGE from RPMS.
* soge::configure: Modifies/creates all configuration files + service file.
* soge::service: Handles the service.
* soge::user: Handles the user creation.

### Parameters

The following parameters are available in the soge module:

* **version**
   SoGE version.
* **package_name**
   Name of the rpm package that you want to install. (default to gridengine)
* **soge_root**
   Base directory of the Son of Grid Engine installation. (default to /opt/soge)
* **soge_cell**
   Name of the Son of Grid Engine cell to be installed. (Default to default)
* **soge_cluster_name**
   Name of the Son of Grid Engine cluster to be installed. (Default to cluster1)
* **soge_qmaster_port**
   Port number for the soge_qmaster daemon. (default to 6444)
* **soge_execd_port**
   Port number for the soge_execd daemon. (default to 6445)
* **soge_qmaster_name**
   FQDN of the node running as master host. (default to masterhost)
* **manage_user**
   Attemp to create soge admin user. (default to true)
* **soge_admin_user**
   Username for the soge admin user. (default to sogeadmin)
* **soge_admin_user_id**
   uid for the username of the soge admin user. (default to 398)
* **soge_admin_group**
   Groupname for the soge admin user. (default to sogeadmin)
* **soge_admin_group_id**
   gid for the groupname of the soge admin user. (default to 399)
* **soge_arch**
   arch for the binaries of the soge. (default to lx-amd64)
* **manage_service**
   Attempt to install sogeexecd as system service. (default to true)
* **soge_request**
   Array of parameters for creating a system soge_request. (default to undef)
* **soge_node_type**
   soge node type of the target node. (default to execution. Only submit/execution supported).

## Limitations

Tested in SL74 and pupppet 5.5.
It should work in any SL7* and, most probably work with all OGS/SoGE/UGE.

## Development

happy to add any improvement to the module. Open an issue or a PR :-)
