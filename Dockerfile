FROM ghcr.io/astral-sh/uv:latest AS builder

WORKDIR /app

COPY pyproject.toml uv.lock .python-version README.md LICENSE ./
COPY src ./src

RUN uv build --wheel

COPY --from=builder --chown=app:app /app/.venv /app/.venv

FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    BLUEMAP_VERSION=5.5 \
    CHUNKER_VERSION=1.4.3

ENV BLUEMAP_CLI_JAR=BlueMap-${BLUEMAP_VERSION}-cli.jar \
    CHUNKER_CLI_JAR=chunker-cli-${CHUNKER_VERSION}.jar

# Update and install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download BlueMap CLI jar
RUN wget -q https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v${BLUEMAP_VERSION}/${BLUEMAP_CLI_JAR} \
    -O ${BLUEMAP_CLI_JAR} \
    && chmod +x ${BLUEMAP_CLI_JAR}

RUN wget -q https://github.com/HiveGamesOSS/Chunker/releases/download/${CHUNKER_VERSION}/${CHUNKER_CLI_JAR} \
    -O ${CHUNKER_CLI_JAR} \
    && chmod +x ${CHUNKER_CLI_JAR}


# https://github.com/HiveGamesOSS/Chunker/releases/download/1.4.3/chunker-cli-1.4.3.jar
# https://github.com/HiveGamesOSS/Chunker/releases/download/1.43/chunker-cli-1.43.jar
