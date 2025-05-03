
# ✅ Lab 2: Create Custom MinIO Docker Image

🕒 **Estimated Time:** 20–30 Minutes

---

## 🎯 Objectives

In this lab, you will:

- Create a `Dockerfile` for MinIO with a custom data directory and port.
- Set environment variables (username and password).
- Build, tag, and push your image to Docker Hub.
- Run MinIO using your custom Docker image.

---

## ☘️ Step 1: Sign Up / Log In to Docker Hub

1. Visit [Docker Hub](https://hub.docker.com).
2. Create an account or log in if you already have one.
3. Note your Docker Hub **username** — you'll use it for tagging your image later.

---

## ☘️ Step 2: Explore the Dockerfile

Explore `Dockerfile` that is provided to you:

```Dockerfile
FROM minio/minio

# Use environment variables to set default credentials
ENV MINIO_ROOT_USER=myadmin
ENV MINIO_ROOT_PASSWORD=mypassword

# Custom startup: store data in /data-files instead of /data
CMD ["minio", "server", "/data-files", "--console-address", ":9001"]
```

### 📌 Explanation:

- `ENV` sets default login credentials inside the image.
- `CMD` defines the default command to run MinIO with a custom data directory and console port.

---

## ☘️ Step 3: Build the Docker Image

Run the following command in the terminal inside the `Lab2` directory:

```bash
cd Lab2
docker build -t minio-easy:v1 .
```

---

## ☘️ Step 4: Verify the Built Image

```bash
docker images
```

You should see `minio-easy` listed in the output.

---

## ☘️ Step 5: Tag the Image for Docker Hub

Replace `yourdockerhubuser` with your actual Docker Hub username:

```bash
docker tag minio-easy:v1 yourdockerhubuser/minio-easy:v1
```

---

## ☘️ Step 6: Login to Docker Hub

Run the following command:

```bash
docker login
```

You will be prompted to enter:

- Your **Docker Hub username**
- Your **password** (or personal access token if 2FA is enabled)

✅ If successful, you'll see:
```
Login Succeeded
```

---

## ☘️ Step 7: Push the Image to Docker Hub

Replace `yourdockerhubuser` with your Docker Hub username:

```bash
docker push yourdockerhubuser/minio-easy:v1
```

---

## ☘️ Step 8: Run a Container from Your Custom Image

Replace `yourdockerhubuser` with your Docker Hub username:

```bash
docker run -d -p 9000:9000 -p 9001:9001 \
  --name easy-minio \
  yourdockerhubuser/minio-easy:v1
```

---

## ☘️ Step 9: Access the MinIO Console

- Open a browser and go to: `http://localhost:9001`
- Login using:
  - **Username:** `myadmin`
  - **Password:** `mypassword`

---

## ✅ Conclusion

In this lab, you:

- Customized the MinIO data path and console port.
- Set default credentials within the image.
- Tagged and pushed a Docker image to Docker Hub.
- Deployed MinIO from your own Docker image.

---

🎉 **Congratulations**, you have successfully completed the lab!  
✨ **END OF LAB** ✨
