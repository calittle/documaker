# Docker Images for Oracle Documaker 
This repository stores Dockerfiles and samples to build Docker images for Oracle Documaker. You may also be interested in other Oracle [Product Images](https://github.com/oracle/docker-images) and Oracle [Linux Images](https://github.com/oracle/docker/tree/OracleLinux-images) branch of this repository.
For pre-built images containing Oracle software, please check the [Oracle Container Registry](https://container-registry.oracle.com).
For support and certification information, please consult the documentation for each product.
For community support, discussions and feedback about the provided Dockerfiles visit the [Oracle Documaker Community](https://community.oracle.com/community/oracle-applications/documaker)

# Required Binaries:
Microsoft Windows.zip - Sample MRL. Can obtain from [Oracle OTN](http://www.oracle.com/technetwork/documentation/insurance-097481.html#Documaker) and locate the Samples and Tutorials for the appropriate version. [12.5](http://docs.oracle.com/cd/E73731_01/Microsoft%20Windows.zip)
V137964-01.zip - Documaker 12.5.0. Can obtain from [Oracle Software Delivery Cloud](https://edelivery.oracle.com). Login and search for Oracle Documaker Standard Edition for Linux x86_64.

# Image Build
Run `buildDocumaker.sh` and specify version and edition, e.g. `buildDocumaker.sh -v 12.5.0 -s`. Other options are available; run `buildDocumaker.sh` to see usage. You must obtain the binary installer packages from Oracle and place inside the version directory.


# Container execution
The container will be set up with a default MRL that can be executed to generate output. You can modify the build to deploy your own MRL as necessary. 

