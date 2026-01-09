# CI/CD Setup for ChefAtHands

This folder contains GitHub Actions workflows for continuous integration and deployment to Azure Kubernetes Service (AKS).

## Workflows

### `deploy.yml` - Build and Deploy to AKS

Triggers on:
- Push to `main` branch
- Manual workflow dispatch

Pipeline stages:
1. **Build and Push** - Builds all Java Spring Boot services with Maven, creates Docker images, and pushes to Docker Hub
2. **Build Frontend** - Builds React app with npm, creates nginx-based Docker image
3. **Deploy to AKS** - Deploys all manifests from `k8s/` folder to AKS cluster

## Required Secrets

Configure these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

### `DOCKER_PASSWORD`
Your Docker Hub password or access token.

Steps to create:
1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Name it `github-actions`
4. Copy the token
5. Add to GitHub secrets as `DOCKER_PASSWORD`

### `AZURE_CREDENTIALS`
Azure service principal credentials for AKS access.

Steps to create:
```powershell
# Login to Azure
az login

# Set your subscription
az account set --subscription <SUBSCRIPTION_ID>

# Create service principal with contributor role
az ad sp create-for-rbac --name "github-actions-chefathands" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/cah-rg \
  --sdk-auth
```

Copy the entire JSON output and add it to GitHub secrets as `AZURE_CREDENTIALS`. Format should be:
```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

## Configuration

Update these environment variables in `deploy.yml` if needed:

- `DOCKER_USERNAME` - Your Docker Hub username (currently: `anejt`)
- `AKS_RESOURCE_GROUP` - Azure resource group name (currently: `cah-rg`)
- `AKS_CLUSTER_NAME` - AKS cluster name (currently: `cah-aks`)
- `NAMESPACE` - Kubernetes namespace (currently: `chefathands`)

## Manual Deployment

To trigger deployment manually:
1. Go to Actions tab in GitHub
2. Select "Build and Deploy to AKS" workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## Local Testing

Test the workflow locally before pushing:

```powershell
# Build a single service
cd utility-services/ingredient-service
mvn clean package -DskipTests
docker build -t test-image .

# Build frontend
cd frontend/chefathands-frontend
npm install
npm run build
```

## Monitoring Deployments

After deployment completes, check status:

```powershell
# Get AKS credentials
az aks get-credentials -g cah-rg -n cah-aks

# Check pods
kubectl get pods -n chefathands

# Check services
kubectl get svc -n chefathands

# Check ingress
kubectl get ingress -n chefathands

# View logs for a specific pod
kubectl logs -n chefathands <pod-name>

# Describe a failing pod
kubectl describe pod -n chefathands <pod-name>
```

## Rollback

If deployment fails, rollback to previous version:

```powershell
# Rollback a specific deployment
kubectl rollout undo deployment/<deployment-name> -n chefathands

# Check rollout history
kubectl rollout history deployment/<deployment-name> -n chefathands

# Rollback to specific revision
kubectl rollout undo deployment/<deployment-name> -n chefathands --to-revision=<revision-number>
```

## Troubleshooting

**Build fails:**
- Check Maven/npm dependencies in logs
- Verify Java 17 and Node 18 compatibility
- Check Dockerfile paths

**Docker push fails:**
- Verify `DOCKER_PASSWORD` secret is set correctly
- Check Docker Hub rate limits
- Verify image names match Docker Hub repository

**AKS deployment fails:**
- Verify `AZURE_CREDENTIALS` secret format
- Check AKS cluster exists and resource group name is correct
- Verify service principal has correct permissions
- Check kubectl logs in workflow output

**Pods not starting:**
- Check image pull errors: `kubectl describe pod <pod-name> -n chefathands`
- Verify secrets are applied: `kubectl get secrets -n chefathands`
- Check resource limits in pod definitions
- View pod logs: `kubectl logs <pod-name> -n chefathands`
