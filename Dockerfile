FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Install Java, Docker CLI, and necessary dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    docker.io \
    curl \
    wget \
    && apt-get clean

# Install Trivy
RUN TRIVY_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//') \
    && wget https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz \
    && tar zxvf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz \
    && mv trivy /usr/local/bin/ \
    && chmod +x /usr/local/bin/trivy \
    && rm -f trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

# Allow Jenkins user to run Docker commands
RUN group_exists=$(getent group docker) || groupadd -g 999 docker \
    && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
