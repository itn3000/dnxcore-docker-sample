# dnxcore-docker-sample

sample docker file for using dnx coreclr on ubuntu amd64(no mono)

## requirements

* docker
* build packages for libuv deb package
    * devscripts
    * dh-autoreconf
    * debhelper
    * build-essential
    * automake
    * m4
    * libtool
    * pkg-config

## build libuv deb package

run the following commands in repository root

    cd libuv
    tar cfz libuv_1.7.3.orig.tar.gz libuv-1.7.3
    cd libuv-1.7.3
    dpkg-buildpackage

then libuv_1.7.3-1_amd64.deb will be created

## building docker container

run the following commands in repository root

docker build -t dnxcore .

## preparing dnx app

if you have already dnx app,
run the following command in your dnx app directory.

    dnvm install 1.0.0-beta7 -p -r coreclr
    dnu restore
    dnu publish -o [published dnx app output dir]

## running app

run the following commands

    docker run -t dnxcore -p [docker host listen port]:[dnx hosting port] -v [published dnx app dir]:/srv/dnx /srv/dnx/kestrel

if you run kestrel,then you can access with http://[docker hostname]:[docker host listen port]
