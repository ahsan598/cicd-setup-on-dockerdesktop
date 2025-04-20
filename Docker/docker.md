
### Dockerfile for a custom Jenkins image that includes:
- **Java** → Required for Jenkins builds
- **Docker CLI** → Allows Jenkins to interact with the Docker daemon on WSL
- **Trivy** → Security scanning for container images


1️⃣ **Build the Docker Image**
```sh
docker build -t custom-jenkins .
```

2️⃣ **Run the Jenkins container with Docker socket access**
```sh
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add 999 \
  custom-jenkins
```

**Note:**
- `-v /var/run/docker.sock:/var/run/docker.sock` → Allows Jenkins to communicate with the Docker daemon on WSL.
- `--group-add 999` → Ensures Jenkins has permission to use Docker.


3️⃣ **Check Jenkins logs for errors**
```sh
docker logs -f jenkins
```

4️⃣ **Confirm Java, Docker, and Trivy inside Jenkins container**
```sh
docker exec -it jenkins bash
java -version
docker --version
trivy --version
```