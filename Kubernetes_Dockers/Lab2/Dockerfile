FROM minio/minio

# Use environment variables to set default credentials
ENV MINIO_ROOT_USER=myadmin
ENV MINIO_ROOT_PASSWORD=mypassword

# Custom startup: store data in /data-files instead of /data
CMD ["minio", "server", "/data-files", "--console-address", ":9001"]