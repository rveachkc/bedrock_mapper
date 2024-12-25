FROM ghcr.io/astral-sh/uv:bookworm-slim AS builder

WORKDIR /app


COPY pyproject.toml uv.lock ./
COPY src ./src

RUN uv build --wheel

FROM python:3.13-slim-bookworm


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

# Copy the wheel from the builder stage
COPY --from=builder /app/dist/*.whl /app/

# Install the wheel
RUN pip install --no-cache-dir /app/*.whl
