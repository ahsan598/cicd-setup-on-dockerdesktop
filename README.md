# CI/CD Pipeline Project includes Jenkins, SonarQube, Nexus & Kubernetes with Docker Desktop.


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
- Unlock Jenkins: Admin password will be find under jenkins logs
- Install plugins: Git, Docker, Kubernetes, SonarQube Scanner, Nexus Artifact Uploader


2️⃣ **Start SonarQube**

```sh
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```
- Access SonarQube at http://localhost:9000
- Default login: user: admin / pwd: admin
- Generate a SonarQube Token for Jenkins integration


3️⃣ **Start Nexus**

```sh
docker run -d --name nexus -p 8081:8081 sonatype/nexus3
```
- Access Nexus at http://localhost:8081
- Default login: user: admin / pwd: (under nexus3/admin.pwd)
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

### Alternative Approach:

If you prefer to keep your Jenkins image minimal and avoid installing additional tools directly into it, consider using Docker-in-Docker (DinD) or sidecar containers for Docker and Trivy. This approach can enhance security and modularity.


🔍 What is Docker-in-Docker (DinD)?

**Docker-in-Docker (DinD)** means running a Docker daemon inside a Docker container. This is useful when you want your container (e.g., Jenkins) to build and run Docker containers itself, without installing Docker directly into the Jenkins image.

🧍 What are Sidecar Containers?

A **sidecar container** is a separate container running alongside your main application container (like Jenkins). Instead of bundling everything (like Docker or Trivy) into the Jenkins image, you let the sidecars handle those tasks.

🧩 Example Setup / How It Works:
- **Jenkins container**: Runs the main Jenkins server.
- **Docker sidecar(dind)**: Docker daemon running in a sidecar, if you don't want to use host Docker socket.
- **Trivy**: Just runs as a sidecar and can be triggered via Jenkins jobs using the Docker CLI or Script.

You can install **Maven and JDK**:
- Through Jenkins UI → Global Tool Configuration.
- Or in a Jenkins job using shell commands like apt install maven.

✅ Let’s create a setup using Docker Compose that:

- Runs Jenkins in a container.
- Runs Docker daemon in another container (DinD).
- Jenkins connects to Docker via the DinD socket.

✅ Best Practices:

- Docker (DinD) runs a Docker daemon — it needs privileged mode and possibly volume mounts.
- Trivy is a vulnerability scanner — it doesn’t need to be privileged and can run independently.