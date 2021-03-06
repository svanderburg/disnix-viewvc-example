disnix-viewvc-example
=====================
This is an example case that deploys a [ViewVC](http://viewvc.tigris.org)
environment, a web-based CVS and Subversion repository viewer with Disnix.

Architecture
============
![ViewVC architecture](doc/architecture.png)

The above figure shows the architecture of the ViewVC system. The system consists
of the ViewVC web front-end, a ViewVC MySQL database storing commit records, and
a collection of Subversion repositories. All the components in the figure are
*distributable* components (or *services*) which can deployed on various machines
in the network.

Usage
=====
The `DistributedDeployment/` sub folder contains all neccessary Disnix models,
such as a services, infrastructure and distribution models required for
deployment.

The models come in two variants:
* The standard variant, e.g. `services.nix`, `infrastructure.nix` and
  `distribution.nix` can be used to deploy services to a network of machines
  that already provide pre-deployed container services, e.g. MySQL and an Apache
  HTTP server.
* The self-contained variant, e.g. `services-with-containers.nix`,
  `distribution-with-containers.nix` deploy both the application services and
  their underlying container services, e.g. MySQL and Apache HTTPD, using the
  experimental
  [Nix process management framework](https://github.com/svanderburg/nix-processmgmt)

Deployment using Disnix to a predeployed network of container services
----------------------------------------------------------------------
For this scenario only installation of the basic Disnix toolset is required.
First, you must manually install a network of machines running the Disnix
service. Then you must adapt the infrastructure model to match to properties of
your network and the distribution model to map the services to the right
machines.

To deploy the databases you must install [MySQL](http://www.mysql.com). To deploy
the web application services you must install the
[Apache HTTP server](http://httpd.apache.org). Check the instructions of your
Linux distribution or the software distributions themselves how to install these
system services. Dysnomia detects the presence of these system services and
configures the activation scripts to use them.

The system can be deployed by running the following command:

```bash
$ disnix-env -s services.nix -i infrastructure.nix -d distribution.nix
```

Deployment of the self-contained example with Disnix
----------------------------------------------------
It is also possible to deploy the self-contained example with the basic Disnix
toolset:

```bash
$ disnix-env -s services-with-containers.nix -i infrastructure.nix -d distribution-with-containers.nix
```

To make the above example work, a network of machines that have the Disnix
service installed are required with a `infrastructure.nix` model providing their
connectivity settings.

Deployment using the NixOS test driver
--------------------------------------
This system can be deployed without adapting any of the models in
`deployment/DistributedDeployment`. By running the following instruction, the
variant without the proxy can be deployed in a network of virtual machines:

```bash
$ disnixos-vm-env -s services.nix -n network.nix -d distribution.nix
```

We can also deploy the self-contained variant as follows:

```bash
$ disnixos-vm-env -s services.nix -n network.nix -d distribution.nix
```

Deployment using NixOps for infrastructure and Disnix for service deployment
----------------------------------------------------------------------------
It's also possible to use NixOps for deploying the infrastructure (machines) and
let Disnix do the deployment of the services to these machines.

A virtualbox network deploying a network of machines with Disnix and container
services (e.g. Apache HTTPD and MySQL) can be deployed as follows:

```bash
$ nixops create ./network.nix ./network-virtualbox.nix -d vboxtest
$ nixops deploy -d vboxtest
```

The services can be deployed by running the following commands:

```bash
$ export NIXOPS_DEPLOYMENT=vboxtest
$ disnixos-env -s services.nix -n network.nix -d distribution.nix --use-nixops
```

Deploying a bare machine network with NixOps and Disnix to deploy all services
------------------------------------------------------------------------------
Similar commands can be used to deploy the self-contained variant as well.
The following command deploys a network of machines with a basic configuration
(only SSH connectivity and the Disnix service):

```bash
$ nixops create ./network-bare.nix ./network-virtualbox.nix -d vboxtest
$ nixops deploy -d vboxtest
```

The following command deploys all container and application services:

```bash
$ export NIXOPS_DEPLOYMENT=vboxtest
$ disnixos-env -s services-with-containers.nix -n network-bare.nix -d distribution-with-containers.nix --use-nixops
```

Running the system
==================
After the system has been deployed, open a web browser and type the following URL:

    http://test1/viewvc/bin/cgi/viewvc.cgi

The `test1` hostname must be replaced by the real hostname of the machine to
which the web application front-end is deployed. Check the distribution model for
this. If the network expression is used included in this example, the third
machine in the network machine automatically boots into IceWM and includes the
Mozilla Firefox web browser for convenience.

License
=======
This package is released under the [MIT license](http://opensource.org/licenses/MIT).
The Subversion repositories are each covered by their own license.
