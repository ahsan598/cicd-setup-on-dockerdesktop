# CI/CD Pipeline Project with Jenkins, SonarQube, Nexus & Kubernetes Deployment on Docker Desktop.


### CI/CD Pipeline Components 📌

1️⃣ **Jenkins** - CI server to build, test, and deploy  
2️⃣ **SonarQube** - Code quality and security analysis  
3️⃣ **Nexus** - Artifact repository for storing built packages  
4️⃣ **Kubernetes (Docker Desktop)** - Deployment environment  

---

### 1️⃣ Prerequisites

✔️ **Docker Desktop** (with Kubernetes enabled)  
✔️ **kubectl** installed  
✔️ **Helm** (for SonarQube & Nexus)  
✔️ **Jenkins, SonarQube, and Nexus** Docker images  


### 2️⃣ Running Services in Docker Containers

1️⃣ **Start Jenkins**

```sh
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```
- Access Jenkins at http://localhost:8080
- Unlock Jenkins: docker logs jenkins
- Install plugins: Pipeline, Git, Kubernetes, SonarQube Scanner, Nexus Artifact Uploader


2️⃣ **Start SonarQube**

```sh
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```
- Access SonarQube at http://localhost:9000
- Default login: admin / admin
- Generate a SonarQube Token for Jenkins integration


3️⃣ **Start Nexus**

```sh
docker run -d --name nexus -p 8081:8081 sonatype/nexus3
```
- Access Nexus at http://localhost:8081
- Default login: admin / admin123 (password in logs)
- Create a Maven Repository for storing artifacts


### 3️⃣ Deploy to Kubernetes (Docker Desktop)

- Create and Apply the Kubernetes deployment:
```sh
kubectl apply -f deployment.yaml
```

- Expose the service:
```sh
kubectl expose deployment my-app --type=NodePort --port=8080
```


### 4️⃣ Jenkins Pipeline Script
- Create a Jenkinsfile


### 5️⃣ Testing & Validation  
- **Jenkins Console Output** - Check pipeline logs  
- **SonarQube Dashboard** - View code quality results  
- **Nexus Repository** - Confirm artifacts stored  
- **Kubernetes Pods** - Verify deployment  
- **Access the Application**  



```sh
kubectl get pods
```
```sh
minikube service my-app --url
```

---

### 1️⃣ Command Breakdown of Jenkins

| **Option** | **Explanation** |
|-----------|----------------|
| `docker run` | Runs a new container. |
| `-d` | Runs the container in detached mode (background). |
| `--name jenkins` | Assigns the name `jenkins` to the container. |
| `-p 8080:8080` | Maps port `8080` on the host to port `8080` in the container (Jenkins UI). |
| `-p 50000:50000` | Maps port `50000` for Jenkins agent communication (used for distributed builds). |
| `-v jenkins_home:/var/jenkins_home` | Creates a named volume `jenkins_home` and maps it to `/var/jenkins_home` inside the container to persist Jenkins data (jobs, plugins, configurations). |
| `jenkins/jenkins:lts` | Pulls and runs the latest long-term support (LTS) version of Jenkins from Docker Hub. |

✅ **Why Use These Options?**

- **Detached mode (`-d`)** → Runs in the background.  
- **Port mapping (`-p 8080:8080`)** → Access Jenkins UI via [http://localhost:8080](http://localhost:8080).  
- **Volume (`-v jenkins_home:/var/jenkins_home`)** → Keeps Jenkins data safe even if the container is removed.

---

### 2️⃣ Dockerfile for a custom Jenkins image that includes:
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