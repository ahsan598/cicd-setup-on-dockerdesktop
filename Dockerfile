FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Install Java, Docker CLI, and Trivy
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    docker.io \
    curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh \
    && chmod +x /usr/local/bin/trivy \
    && apt-get clean

# Allow Jenkins user to run Docker commands
RUN groupadd -g 999 docker && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
