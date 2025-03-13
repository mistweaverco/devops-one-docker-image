FROM alpine:latest

USER root

ENV NVM_VERSION=0.39.2
ENV NODE_VERSION=22
ENV PYTHON_VERSION=3.11
ENV TERRAFORM_VERSION=1.0.11

# Install required packages
RUN apk update && apk add --no-cache \
    bash \
    build-base \
    bzip2-dev \
    curl \
    docker \
    docker-compose \
    git \
    jq \
    libffi-dev \
    openssh \
    openssl-dev \
    readline-dev \
    shadow \
    sqlite-dev \
    tk-dev \
    unzip \
    xz-dev \
    zip \
    zlib-dev \
    eza \
    neovim

# Set up bash as default shell
RUN chsh -s /bin/bash

ENV HOME=/root
ENV PROFILE=/root/.bashrc

# Create a script file sourced by both
# interactive and non-interactive bash shells
ENV BASH_ENV=$HOME/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Install pyenv
RUN curl -fsSL https://pyenv.run | bash
RUN echo 'export PATH="${HOME}/.pyenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc
ENV PATH="${HOME}/.pyenv/bin:${PATH}"
# Install latest python
RUN pyenv install "$PYTHON_VERSION"

# Install nvm, node, npm and yarn and kimbia task runner
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
ENV NVM_DIR=$HOME/.nvm
RUN echo "22" > $HOME/.nvmrc
RUN bash -c "source ${NVM_DIR}/nvm.sh --no-use && nvm install ${NODE_VERSION}" \
  "&& npm install -g yarn" \
  "&& npm install -g @mistweaverco/kimbia"

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf awscliv2.zip aws

# Install tfswitch and terraform
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | bash
RUN tfswitch "$TERRAFORM_VERSION"

# Install Google Cloud SDK
RUN curl https://sdk.cloud.google.com | bash
RUN echo 'source ${HOME}/google-cloud-sdk/path.bash.inc' >> ~/.bashrc
RUN echo 'source ${HOME}/google-cloud-sdk/completion.bash.inc' >> ~/.bashrc

# Install direnv
RUN curl -sfL https://direnv.net/install.sh | bash

# Install bun.sh
RUN curl -fsSL https://bun.sh/install | bash

# Usefule aliases
RUN echo 'export PATH="${HOME}/.local/bin:$PATH"' >> ~/.bashrc
RUN echo 'alias ll="eza -la"' >> ~/.bashrc
RUN echo 'alias vim="nvim"' >> ~/.bashrc

# Make ps1 more readable
RUN echo 'export PS1="\[\e[1;32m\]\u\[\e[m\]@\[\e[1;34m\]\h\[\e[m\]:\[\e[1;36m\]\w\[\e[m\]\$ "' >> ~/.bashrc

WORKDIR /app

# set cmd to bash
CMD ["/bin/bash"]
