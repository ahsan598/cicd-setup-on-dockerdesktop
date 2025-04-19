FROM jenkins/jenkins:lts-alpine

# Switch to root user to install dependencies
USER root

# Set default shell to /bin/ash (Alpine uses ash instead of bash)
SHELL ["/bin/ash", "-c"]

# Install Docker and required dependencies
RUN apk add --no-cache \
    docker \
    openjdk17 \
    wget \
    curl \
    ca-certificates \
    git \
    maven \
    tini

# Ensure Jenkins user can run Docker (only add user, as group already exists)
RUN adduser jenkins docker

# Ensure Jenkins user has access to Docker socket (if mounted)
RUN chown jenkins:docker /var/run/docker.sock || true

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins default port
EXPOSE 8080 50000

# Start Jenkins
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
