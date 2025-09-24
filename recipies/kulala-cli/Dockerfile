FROM alpine:latest AS builder

USER root

# Install required packages
RUN apk add --no-cache \
    bash \
    curl \
    gcc \
    git \
    gzip \
    neovim \
    shadow \
    tar \
    wget

# Set up bash as default shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV HOME=/root
ENV USER=root

# Create a script file sourced by both
# interactive and non-interactive bash shells
ENV BASH_ENV=$HOME/.bash_env
ENV BASH_RC=$HOME/.bashrc
ENV XDG_DATA_HOME=$HOME/.local/share
ENV BUN_INSTALL=${HOME}/.bun

RUN touch "${BASH_ENV}" "${BASH_RC}"
RUN echo ". ${BASH_ENV}" >> "${BASH_RC}"

# Install bun.sh
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH=${BUN_INSTALL}/bin:${PATH}

ENV BUN_INSTALL=${HOME}/.bun
ENV NVIM_CACHE_DIR=${HOME}/.cache/nvim
ENV NVIM_CONFIG_HOME=${HOME}/.config/nvim
ENV LAZY_NVIM_DATA_HOME=${XDG_DATA_HOME}/nvim/lazy
ENV KULALA_NVIM_SCRIPTS_BUILD_DIR=${NVIM_CACHE_DIR}/kulala/scripts/build

RUN mkdir -p ${NVIM_CONFIG_HOME}
RUN mkdir -p ${KULALA_NVIM_SCRIPTS_BUILD_DIR}
COPY ./nvim.lua ${NVIM_CONFIG_HOME}/init.lua
RUN nvim --headless "+Lazy! sync" +qa
RUN cd ${LAZY_NVIM_DATA_HOME}/kulala.nvim/lua/kulala/parser/scripts/engines/javascript/lib && bun install && bun run build && mv dist "$KULALA_NVIM_SCRIPTS_BUILD_DIR" && rm -rf node_modules
RUN echo "#!/usr/bin/env bash" >> /usr/local/bin/kulala-cli && echo "${LAZY_NVIM_DATA_HOME}/kulala.nvim/lua/cli/kulala_cli.lua \"\$@\"" >> /usr/local/bin/kulala-cli && chmod +x /usr/local/bin/kulala-cli
RUN mkdir -p /root/.local/state/nvim/kulala && \
    echo '{"js_build_ver_local":"1.0.1","js_version":"5.3.3","news_ver":"5.3.3","parser_ver":"0.1.6"}' > /root/.local/state/nvim/kulala/settings.json
RUN bun install -g prettier tree-sitter-cli

RUN echo 'export PATH="${HOME}/.local/bin:$PATH"' >> ~/.bashrc

FROM alpine:latest AS runner

ENV USER=root
ENV HOME=/${USER}
ENV XDG_DATA_HOME=/${USER}/.local/share

USER root

COPY --from=builder ${USER}/.bash_env $HOME/.bash_env
COPY --from=builder ${USER}/.bashrc $HOME/.bashrc
COPY --from=builder ${USER}/.bun $HOME/.bun
COPY --from=builder ${USER}/.config $HOME/.config
COPY --from=builder ${USER}/.cache/nvim $HOME/.cache/nvim
COPY --from=builder ${USER}/.local/state/nvim $HOME/.local/state/nvim
COPY --from=builder ${USER}/.local/share/nvim $HOME/.local/share/nvim
COPY --from=builder /usr/local/bin/kulala-cli /usr/local/bin/kulala-cli

WORKDIR /app

# Install final packages
RUN apk add --no-cache \
    bash \
    coreutils \
    curl \
    git \
    jq \
    lua5.1 \
    neovim \
    nodejs \
    npm \
    shadow \
    wget

# Set up bash as default shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["/bin/bash"]
