# See https://github.com/mazgi/dockerfiles/blob/main/Dockerfile.d/provisioning/customize-example.Dockerfile
FROM ghcr.io/mazgi/provisioning

# Set in non-interactive mode.
ENV DEBIAN_FRONTEND=noninteractive

# https://www.terraform.io/downloads.html
ARG TERRAFORM_VERSIONS=1.2.8
ENV TERRAFORM_VERSIONS=${TERRAFORM_VERSIONS}

ARG DOCKER_GID
ARG GID=0
ARG UID=0
ENV DOCKER_GID=${DOCKER_GID}
ENV GID=${GID:-0}
ENV UID=${UID:-0}

COPY rootfs /
RUN :\
  && cd /usr/local/bin\
  && ln -fs echo-with-color.zsh echoDebug\
  && ln -fs echo-with-color.zsh echoInfo\
  && ln -fs echo-with-color.zsh echoWarn\
  && ln -fs echo-with-color.zsh echoErr\
  && :

HEALTHCHECK --interval=2s --timeout=1s --retries=2 --start-period=5s\
 CMD jq -e ". | select(.succeeded)" $(docker-util.keep-running.zsh --print-status-file-path)

RUN : Terraform\
  # Install Terraform via tfenv
  && echo $TERRAFORM_VERSIONS | tr ',' '\n' | xargs -IV tfenv install V\
  # use the beginning version on the list
  && tfenv use ${TERRAFORM_VERSIONS%%,*}\
  && :

RUN :\
  # Create a user for development who has the same UID and GID as you.
  && useradd --comment '' --create-home --gid users --uid ${UID} developer\
  && groupadd --gid ${GID} developer\
  && usermod --append --groups developer developer || true\
  # Append docker group
  && bash -c "test -n \"${DOCKER_GID}\" && groupadd --gid ${DOCKER_GID} docker"\
  && usermod --append --groups docker developer 2> /dev/null || true\
  # It will be duplicate UID or GID with "node" user when your UID==1000 or GID==100.
  && echo '%users ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/grant-all-without-password-to-users\
  && echo '%developer ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/grant-all-without-password-to-developer\
  && :

# Reset DEBIAN_FRONTEND to default(`dialog`).
# If you no need `dialog`, you can set `DEBIAN_FRONTEND=readline`.
# see also: man 7 debconf
ENV DEBIAN_FRONTEND=
