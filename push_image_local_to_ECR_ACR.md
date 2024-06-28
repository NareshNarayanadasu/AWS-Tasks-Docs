Here are the steps to push an image to both Amazon Elastic Container Registry (ECR) and Azure Container Registry (ACR).

## Push Image to Amazon ECR

### Step 1: Authenticate Docker to Your Default Registry
```sh
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
```

### Step 2: Create a Repository
```sh
aws ecr create-repository --repository-name your-repository-name --region your-region
```

### Step 3: Build Your Docker Image
```sh
docker build -t your-repository-name .
```

### Step 4: Tag Your Image
```sh
docker tag your-repository-name:latest your-account-id.dkr.ecr.your-region.amazonaws.com/your-repository-name:latest
```

### Step 5: Push Your Image to ECR
```sh
docker push your-account-id.dkr.ecr.your-region.amazonaws.com/your-repository-name:latest
```

## Push Image to Azure ACR

### Step 1: Authenticate Docker to Your Azure Registry
```sh
az acr login --name yourRegistryName
```

### Step 2: Create a Repository (if not already created)

Azure ACR repositories are created implicitly when you push the image.

### Step 3: Build Your Docker Image
```sh
docker build -t yourRegistryName.azurecr.io/your-repository-name .
```

### Step 4: Tag Your Image
```sh
docker tag your-repository-name:latest yourRegistryName.azurecr.io/your-repository-name:latest
```

### Step 5: Push Your Image to ACR
```sh
docker push yourRegistryName.azurecr.io/your-repository-name:latest
```

These steps should help you push Docker images to both Amazon ECR and Azure ACR. Make sure to replace placeholders like `your-region`, `your-account-id`, `your-repository-name`, and `yourRegistryName` with your actual values.