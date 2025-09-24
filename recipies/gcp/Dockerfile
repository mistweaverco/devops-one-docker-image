ARG NVM_VERSION=0.40.2
ARG NODE_VERSION=23
ARG PYTHON_VERSION=3.12
ARG TERRAFORM_VERSION=1.11.4
ARG AVAILABLE_TERRAFORM_VERSIONS="1.11.4 1.11.2 1.10.5"
ARG TERRAGRUNT_VERSION=0.76.3
ARG NEOVIM_VERSION=0.11.3

FROM ubuntu:latest AS builder

ARG NVM_VERSION
ARG NODE_VERSION
ARG PYTHON_VERSION
ARG TERRAFORM_VERSION
ARG AVAILABLE_TERRAFORM_VERSIONS
ARG TERRAGRUNT_VERSION

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

# Install tfswitch and terraform
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | bash
RUN for version in $AVAILABLE_TERRAFORM_VERSIONS; do tfswitch -d "$version";  done
RUN tfswitch -d "$TERRAFORM_VERSION"
RUN echo "export PATH=\"${HOME}/bin:${PATH}\"" >> ~/.bashrc

# Install Google Cloud SDK
RUN curl https://sdk.cloud.google.com | bash
RUN echo 'source ${HOME}/google-cloud-sdk/path.bash.inc' >> ~/.bashrc
RUN echo 'source ${HOME}/google-cloud-sdk/completion.bash.inc' >> ~/.bashrc

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

ARG NEOVIM_VERSION
ARG NODE_VERSION

COPY --from=builder /root/.bash_env /root/.bash_env
COPY --from=builder /root/.bashrc /root/.bashrc
COPY --from=builder /root/.nvm /root/.nvm
COPY --from=builder /root/.pyenv /root/.pyenv
COPY --from=builder /root/.bun /root/.bun
COPY --from=builder /root/.terraform.versions /root/.terraform.versions
COPY --from=builder /root/google-cloud-sdk /root/google-cloud-sdk
COPY --from=builder /root/.config /root/.config
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
    libluajit-5.1-2 \
    liblzma-dev \
    libmsgpack-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtermkey1 \
    libvterm0 \
    libtree-sitter0 \
    llvm \
    lua-luv \
    lua5.1 \
    make \
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

ENV HOME=/root
ENV NVM_DIR=$HOME/.nvm
ENV BUN_INSTALL=${HOME}/.bun
ENV XDG_DATA_HOME=/root/.local/share
ENV NVIM_CACHE_DIR=${HOME}/.cache/nvim
ENV NVIM_CONFIG_HOME=${HOME}/.config/nvim
ENV LAZY_NVIM_DATA_HOME=${XDG_DATA_HOME}/nvim/lazy
ENV PATH=$NVM_DIR/versions/node/$NODE_VERSION/bin:${BUN_INSTALL}/bin:${PATH}
ENV NODE_PATH=$NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV KULALA_NVIM_SCRIPTS_BUILD_DIR=${NVIM_CACHE_DIR}/kulala/scripts/build

# Install and configure neovim with lazy.nvim and kulala.nvim
# so we can use neovim in headless mode to run http requests
RUN mkdir -p _neovim && curl -sL https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz | tar -xz -C _neovim && mv _neovim/nvim-linux-x86_64 /usr/local/nvim && rm -rf _neovim
RUN ln -s /usr/local/nvim/bin/nvim /usr/bin/nvim
RUN mkdir -p ${NVIM_CONFIG_HOME}
RUN mkdir -p /root/.cache/nvim/kulala/scripts/build
COPY ./nvim.lua ${NVIM_CONFIG_HOME}/init.lua
RUN nvim --headless "+Lazy! sync" +qa
RUN cd ${LAZY_NVIM_DATA_HOME}/kulala.nvim/lua/kulala/parser/scripts/engines/javascript/lib && bun install && bun run build && mv dist "$KULALA_NVIM_SCRIPTS_BUILD_DIR"
RUN echo "#!/usr/bin/env bash" >> /usr/local/bin/kulala-cli && echo "${LAZY_NVIM_DATA_HOME}/kulala.nvim/lua/cli/kulala_cli.lua \"\$@\"" >> /usr/local/bin/kulala-cli && chmod +x /usr/local/bin/kulala-cli
RUN mkdir -p /root/.local/state/nvim/kulala && \
    echo '{"js_build_ver_local":"1.0.1","js_version":"5.3.3","news_ver":"5.3.3","parser_ver":"0.1.6"}' > /root/.local/state/nvim/kulala/settings.json
RUN bun install -g prettier tree-sitter-cli
# set cmd to bash
CMD ["/bin/bash"]
