FROM ubuntu

ENV DNX_USER_HOME /opt/dnx
ENV DNX_VERSION 1.0.0-beta7
ENV LIBUV_PACKAGE libuv_1.7.3-1_amd64.deb

COPY libuv/$LIBUV_PACKAGE /var/tmp/$LIBUV_PACKAGE

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update && \
  apt-get install -y libunwind8 gettext libssl1.0.0 libcurl4-openssl-dev zlib1g curl ca-certificates unzip && \
  dpkg -i /var/tmp/$LIBUV_PACKAGE && \
  rm -f /var/tmp/$LIBUV_PACKAGE && \
  curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | \
  DNX_USER_HOME=$DNX_USER_HOME DNX_BRANCH=v$DNX_VERSION sh && \
  bash -c "source $DNX_USER_HOME/dnvm/dnvm.sh && \
    dnvm install $DNX_VERSION -r coreclr -a default && \
    dnvm alias default | xargs -i ln -s $DNX_USER_HOME/runtimes/{} $DNX_USER_HOME/runtimes/default" && \
  mkdir -p /srv/dnx
ENV PATH $PATH:$DNX_USER_HOME/runtimes/default/bin
VOLUME /srv/dnx
