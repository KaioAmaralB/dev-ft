for file in *.tf; do
  filename=$(basename "$file")
  curl -X PUT -T "$file" "https://objectstorage.sa-saopaulo-1.oraclecloud.com/p/kojNk7l7wf4kDKcwn5q0F79i8piKF7ADLdOG9yXyOJnLEJopZNEJYYSo6-U-1anu/n/gr3yho6wbbm5/b/IaC-bucket/o/$filename"
done