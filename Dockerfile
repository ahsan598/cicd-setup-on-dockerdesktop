FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Install essential dependencies, ensuring minimal image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk-headless \
    docker.io \
    curl \
    wget \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*  # Reduce image size

# Install Trivy (Minimal & Reliable)
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh \
    && install -m 0755 ./bin/trivy /usr/local/bin/trivy \
    && rm -rf ./bin

# Ensure Jenkins user can run Docker commands
RUN groupadd -g 999 docker || true \
    && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
