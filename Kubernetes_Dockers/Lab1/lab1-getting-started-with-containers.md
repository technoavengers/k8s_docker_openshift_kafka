
# ✅ Lab 1: Getting Started with Containers

**Running MinIO as a Container on Docker**  
**Time:** 20 Mins

## 🧾 Lab Summary

This lab introduces the fundamental concepts of containerization. Participants will be provided a Docker pre-installed environment. They will pull a pre-built image from Docker Hub and run a basic containerized application.

---

## 🎯 Objective

- Pulling a Pre-Built Image from Docker Hub  
- Running a Containerized Application  
- Exploring Container Management  
- Removing Containers  

---

## ☘️ Step 1: Pulling a Pre-Built Image from Docker Hub

1. **Open your terminal in vscode.**  
2. **Ensure Docker is installed by running:**
   ```bash
   docker --version
   ```

3. **Pull the MinIO image from Docker Hub:**
   ```bash
   docker pull minio/minio
   ```

4. **Verify the image is pulled:**
   ```bash
   docker images
   ```

---

## ☘️ Step 2: Running a Containerized MinIO Application

Start a MinIO container using the following command:

```bash
docker run -d -p 9000:9000 -p 9001:9001 --name minio -e "MINIO_ROOT_USER=admin" -e "MINIO_ROOT_PASSWORD=password" minio/minio server /data --console-address ":9001"
```

### 🔍 Explanation of the Command:
- `docker run`: Create and run a new container
- `-d`: Run in detached mode (background)
- `-p 9000:9000`: Maps host port 9000 to container port 9000 (S3 API)
- `-p 9001:9001`: Maps host port 9001 to container port 9001 (MinIO Console)
- `--name minio`: Name the container "minio"
- `-e "MINIO_ROOT_USER=admin"`: Set MinIO admin username
- `-e "MINIO_ROOT_PASSWORD=password"`: Set MinIO admin password
- `minio/minio`: Use the official MinIO image
- `server /data --console-address ":9001"`: Start MinIO server and expose console

### ✅ Check Running Containers

```bash
docker ps
```

You should see the `minio` container running on ports 9000 and 9001.

### 🌐 Access the MinIO Console

- Go to PORTS tab next to TERMINAL and click on 9001 -> "Open in a browser" option
- Login:
  - **Username**: `admin`
  - **Password**: `password`

---

## ☘️ Step 3: Exploring Container Management

### 🔹 View Container Logs
```bash
docker logs minio
```

### 🔹 Access Container Shell (Optional)
```bash
docker exec -it minio /bin/bash
```

- Once inside, try:
  ```bash
  ls
  ```
- Exit the container:
  ```bash
  exit
  ```

### 🔹 Stop MinIO Container
```bash
docker stop minio
```

### 🔹 Remove the MinIO Container
```bash
docker rm -f minio
```

### 🔹 Confirm Deletion
```bash
docker ps
```

---

## ✅ 🔚 Conclusion

In this lab, you successfully took your first step into the world of containerization by working with Docker and the MinIO object storage server.

You learned how to:
- Pull a pre-built Docker image from Docker Hub
- Run a containerized MinIO application
- Access the MinIO Console through a web browser
- Explore container logs and access the container shell
- Stop and remove containers cleanly

---

🎉 **Congratulations**, you have successfully completed the lab.  
✨ **END OF LAB** ✨
