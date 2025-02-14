FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Ensure the shell is set to Bash (Fix for missing /bin/sh issue)
SHELL ["/bin/bash", "-c"]

# Install Java, Docker CLI, and necessary dependencies (minimized package size)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk-headless \
    docker.io \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*  # Reduce image size

# Install Trivy (Minimal & Reliable)
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh \
    && install -m 0755 ./bin/trivy /usr/local/bin/trivy \
    && rm -rf ./bin

# Allow Jenkins user to run Docker commands (Fixed group check)
RUN getent group docker || groupadd -g 999 docker \
    && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
