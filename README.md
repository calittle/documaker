# Docker Images for Oracle Documaker 
This repository stores Dockerfiles and samples to build Docker images for Oracle Documaker. You may also be interested in other Oracle [Product Images](https://github.com/oracle/docker-images) and Oracle [Linux Images](https://github.com/oracle/docker/tree/OracleLinux-images) branch of this repository.

For pre-built images containing Oracle software, please check the [Oracle Container Registry](https://container-registry.oracle.com).
For support and certification information, please consult the documentation for each product.
For community support, discussions and feedback about the provided Dockerfiles visit the [Oracle Documaker Community](https://community.oracle.com/community/oracle-applications/documaker)

# Required Binaries:
1. Microsoft Windows.zip - Sample MRL. Can obtain from [Oracle OTN](http://www.oracle.com/technetwork/documentation/insurance-097481.html#Documaker) and locate the Samples and Tutorials for the appropriate version. [12.5](http://docs.oracle.com/cd/E73731_01/Microsoft%20Windows.zip)
2. V137964-01.zip - Documaker 12.5.0. Can obtain from [Oracle Software Delivery Cloud](https://edelivery.oracle.com). Login and search for Oracle Documaker Standard Edition for Linux x86_64.

# Image Build
1. Obtain required binary installer packages from Oracle (see above) and place inside the appropriate version directory - do not unzip them.
2. Run `buildDocumaker.sh` and specify version and edition, e.g. `buildDocumaker.sh -v 12.5.0 -s`. Other options are available; run `buildDocumaker.sh` to see usage. 

# Container execution
The container will be set up with a default MRL that can be executed to generate output. You can modify the build to deploy your own MRL as necessary. 
* Base MRL is installed to `/u01/oracle/rel125/mstrres/dms1`
* Basic execution script is installed to `/u01/oracle/rel125/mstrres/dms1/run.sh`
* See `/u01/oracle/runDocumaker.sh` for automatic execution of `run.sh` on Container start.

# Helpful Hints
1. `docker run -ti [IMAGE_ID | IMAGE_NAME]` - Use this command to start a container from an image. For exmaple, once you've built an image, you can fire up the image using this command. The container will automatically execute the `/u01/oracle/runDocumaker.sh` script on startup.
2. `docker run -ti -u root [IMAGE_ID | IMAGE_NAME]` - Similar to the above, use this to start up a container and open TTY as root.
3. What if I need my custom MRL or other components in my container? 
  Clone the [repository](https://github.com/calittle/documaker) using `git clone https://github.com/calittle/documaker.git` then modify the appropriate `Dockerfile` to `COPY` the binary files you need. Then, you can execute the RUN commands to install. Alternately, you can modify the `install_se.sh` script if you want to use `bash` scripting instead of `Docker` scripting.
  Another alternative is to use `yum` to install the necessary components, if they are available in a repository. You can do this using the `Dockerfile` which already uses `yum` to install various components.
4. What if I already made changes to my Container and I want to push them back into the image I made? Easy, just use docker commands to commit changes: e.g. `docker commit [CONTAINER_ID] [IMAGE_NAME]`.   
