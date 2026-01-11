# Deployment Instructions for AWS EC2

## Prerequisites
1.  **AWS EC2 Instance**: Launch an EC2 instance (e.g., Ubuntu 22.04 or Amazon Linux 2023).
2.  **Security Group**: Ensure the following ports are open in your Security Group:
    *   `22` (SSH)
    *   `8080` (Backend API)
    *   `5432` (PostgreSQL - optional, if you want to access DB remotely)

## Step 1: Install Docker and Docker Compose on EC2

SSH into your EC2 instance and run the following commands:

### For Ubuntu:
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER
# Log out and log back in for group changes to take effect
```

### For Amazon Linux 2023:
```bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -aG docker ec2-user
# Install Docker Compose
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
# Log out and log back in
```

## Step 2: Transfer Files to EC2

You can use `scp` or `git` to get your code onto the server.

**Option A: Using Git (Recommended)**
1.  Install git: `sudo apt install git` or `sudo yum install git`.
2.  Clone your repository: `git clone <your-repo-url>`.
3.  Navigate to the backend folder: `cd safevax-blockchain/backend`.

**Option B: Using SCP (Copy files directly)**
Run this from your local machine:
```bash
scp -i /path/to/key.pem -r backend/ user@<ec2-public-ip>:~/backend
```

## Step 3: Configure Environment

1.  Open `docker-compose.yml`:
    ```bash
    nano docker-compose.yml
    ```
2.  Update `VNPAY_RETURN_URL` to use your EC2 Public IP or Domain instead of `localhost`.
    Example: `http://<EC2-PUBLIC-IP>:8080/payments/vnpay/return`
3.  If your blockchain service is running on a different server, update `BLOCKCHAIN_URL`.
4.  Update `CORS_ALLOWED_ORIGINS` to include your frontend domain/IP.
    Example: `http://localhost:5173,http://<EC2-PUBLIC-IP>:5173`
5.  Update `APP_BASE_URL` to your EC2 Public IP or Domain.
    Example: `http://<EC2-PUBLIC-IP>:8080`

## Step 4: Run the Application

Run the following command to build and start the services:

```bash
docker compose up -d --build
```

## Step 5: Verify

Check if the containers are running:
```bash
docker compose ps
```

View logs:
```bash
docker compose logs -f backend
```

Your API should now be accessible at `http://<EC2-PUBLIC-IP>:8080`.
