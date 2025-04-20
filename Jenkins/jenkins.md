
### 1️⃣ Command Breakdown of Jenkins Command

```sh
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

| **Option** | **Explanation** |
|-----------|----------------|
| `docker run` | Runs a new container. |
| `-d` | Runs the container in detached mode (background). |
| `--name jenkins` | Assigns the name `jenkins` to the container. |
| `-p 8080:8080` | Maps port `8080` on the host to port `8080` in the container (Jenkins UI). |
| `-p 50000:50000` | Maps port `50000` for Jenkins agent communication (used for distributed builds). |
| `-v jenkins_home:/var/jenkins_home` | Creates a named volume `jenkins_home` and maps it to `/var/jenkins_home` inside the container to persist Jenkins data (jobs, plugins, configurations). |
| `jenkins/jenkins:lts` | Pulls and runs the latest long-term support (LTS) version of Jenkins from Docker Hub. |


### ✅ **Why Use These Options?**

- **Detached mode (`-d`)** → Runs in the background.  
- **Port mapping (`-p 8080:8080`)** → Access Jenkins UI via [http://localhost:8080](http://localhost:8080).  
- **Volume (`-v jenkins_home:/var/jenkins_home`)** → Keeps Jenkins data safe even if the container is removed.


---

### 2️⃣ Alternative Approcah

### Sample Jenkins Job Shell Script (to use Docker and Trivy)

```sh
# This runs in a Jenkins job
docker --version

# Build and scan an image
docker build -t myapp:latest .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image myapp:latest
```

**Note**: You can then add below cmd from Jenkins jobs or a host terminal for trivy.
```sh
docker exec -it trivy trivy image nginx
```


### 🔁 Jenkins Usage
In your Jenkins job (pipeline or freestyle), you can:

```sh
# Build Docker image
docker build -t myapp:latest .

# Scan using Trivy container
docker exec trivy trivy image myapp:latest
```

Or pull Trivy as a tool in Jenkins pipeline using sh step.
