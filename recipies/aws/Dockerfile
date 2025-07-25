FROM ubuntu:latest AS builder

ENV NVM_VERSION=0.40.2
ENV NODE_VERSION=23
ENV PYTHON_VERSION=3.12
ENV TERRAFORM_VERSION=1.11.4
ENV AVAILABLE_TERRAFORM_VERSIONS="1.11.4 1.11.2"
ENV TERRAGRUNT_VERSION=0.76.3

USER root

# Install required packages
RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    tk-dev \
    unzip \
    wget  \
    xz-utils \
    zlib1g-dev

# Set up bash as default shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV HOME=/root

# Create a script file sourced by both
# interactive and non-interactive bash shells
ENV BASH_ENV=$HOME/.bash_env
ENV BASH_RC=$HOME/.bashrc
RUN touch "${BASH_ENV}" "${BASH_RC}"
RUN echo ". ${BASH_ENV}" >> "${BASH_RC}"

# Install Terragrunt
RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt

# Install nvm, node, npm and yarn and kimbia task runner
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | PROFILE="${BASH_ENV}" bash
ENV NVM_DIR=$HOME/.nvm
# RUN . ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION} && nvm use ${NODE_VERSION} && npm install -g yarn && npm install -g @mistweaverco/kimbia
RUN nvm install ${NODE_VERSION}
RUN npm install -g yarn && npm install -g @mistweaverco/kimbia

# Install pyenv
RUN curl -fsSL https://pyenv.run | bash
RUN echo 'export PATH="${HOME}/.pyenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc
ENV PATH="${HOME}/.pyenv/bin:${PATH}"
# Install latest python
RUN pyenv install "$PYTHON_VERSION"
RUN pyenv global "$PYTHON_VERSION"

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf awscliv2.zip aws

# Install tfswitch and terraform
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | bash
RUN for version in $AVAILABLE_TERRAFORM_VERSIONS; do tfswitch -d "$version";  done
RUN tfswitch -d "$TERRAFORM_VERSION"
RUN echo "export PATH=\"${HOME}/bin:${PATH}\"" >> ~/.bashrc

# Install direnv
RUN curl -sfL https://direnv.net/install.sh | bash

# Install bun.sh
RUN curl -fsSL https://bun.sh/install | bash

# Install Turborepo
ENV BUN_INSTALL=${HOME}/.bun
ENV PATH=${BUN_INSTALL}/bin:${PATH}
RUN bun install --global turbo

# Usefule aliases
RUN echo 'export PATH="${HOME}/.local/bin:$PATH"' >> ~/.bashrc
RUN echo 'alias ll="eza -la"' >> ~/.bashrc
RUN echo 'alias vim="nvim"' >> ~/.bashrc

FROM ubuntu:latest AS runner

ENV HOME=/root

COPY --from=builder /root/.bash_env /root/.bash_env
COPY --from=builder /root/.bashrc /root/.bashrc
COPY --from=builder /root/.nvm /root/.nvm
COPY --from=builder /root/.pyenv /root/.pyenv
COPY --from=builder /root/.bun /root/.bun
COPY --from=builder /root/.terraform.versions /root/.terraform.versions
COPY --from=builder /usr/local /usr/local

WORKDIR /app

# Install final packages
RUN apt update && apt install -y \
    build-essential \
    curl \
    eza \
    git \
    jq \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    neovim \
    tk-dev \
    unzip \
    wget  \
    xz-utils \
    zip \
    zlib1g-dev

# Set up bash as default shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update

RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# set cmd to bash
CMD ["/bin/bash"]
