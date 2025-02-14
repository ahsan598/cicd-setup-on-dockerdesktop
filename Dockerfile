FROM jenkins/jenkins:lts-alpine

# Switch to root user to install dependencies
USER root

# Install Java (headless), Docker CLI, and essential tools
RUN apk add --no-cache \
    openjdk17-jre-headless \
    docker-cli \
    curl \
    wget \
    ca-certificates \
    tini \
    shadow  # Needed for usermod

# Install Trivy on Alpine
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh \
    && install -m 0755 ./bin/trivy /usr/local/bin/trivy \
    && rm -rf ./bin

# Ensure Jenkins user can run Docker commands
RUN addgroup -g 999 docker || true \
    && usermod -aG docker jenkins  # Corrected usermod syntax for Alpine

# Switch back to Jenkins user
USER jenkins

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]