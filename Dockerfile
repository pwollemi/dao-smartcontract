FROM node:23.3.0

# Install foundry dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# Add Foundry binaries to the PATH
ENV PATH="/root/.foundry/bin:${PATH}"

RUN foundryup

WORKDIR /dao-smartcontract

COPY . .

RUN cp .env_example .env
RUN bash -c '. .env'

RUN rm -rf .gitmodules && \
    rm -rf lib/openzeppelin-contracts-upgradeable && \
    rm -rf lib/openzeppelin-contracts && \
    rm -rf lib/forge-std

RUN git init
RUN git submodule add https://github.com/OpenZeppelin/openzeppelin-contracts.git lib/openzeppelin-contracts
RUN git submodule add https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable.git lib/openzeppelin-contracts-upgradeable
RUN git submodule add https://github.com/foundry-rs/forge-std.git lib/forge-std


RUN forge compile --via-ir

CMD ["sh", "-c", "sleep 30 && forge script src/script/script.s.sol:script --fork-url http://core:8545 --broadcast --via-ir"]