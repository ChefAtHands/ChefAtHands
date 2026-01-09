# Quick Deploy Script for ChefAtHands
# Run this locally to deploy/update the k8s cluster manually

param(
    [switch]$SkipBuild,
    [switch]$BuildOnly,
    [string]$Service = "all"
)

$ErrorActionPreference = "Stop"

$services = @(
    @{ Name = "ingredient-service"; Path = "utility-services/ingredient-service"; Image = "chefathands-ingredient-service" },
    @{ Name = "user-service"; Path = "utility-services/user-service"; Image = "chefathands-user-service" },
    @{ Name = "favourites-service"; Path = "utility-services/favourites-service"; Image = "chefathands-favourites-service" },
    @{ Name = "history-service"; Path = "utility-services/history-service"; Image = "chefathands-history-service" },
    @{ Name = "logging-service"; Path = "utility-services/logging-service"; Image = "chefathands-logging-service" },
    @{ Name = "notification-service"; Path = "utility-services/notification-service"; Image = "chefathands-notification-service" },
    @{ Name = "recipe-search-service"; Path = "external-api-services/recipe-search-service"; Image = "chefathands-recipe-search-service" },
    @{ Name = "recommendation-service"; Path = "processing-services/recommendation-service"; Image = "chefathands-recommendation-service" },
    @{ Name = "frontend-gateway"; Path = "frontend-gateway"; Image = "chefathands-frontend-gateway" }
)

$dockerUsername = "anejt"
$namespace = "chefathands"

function Build-Service {
    param($svc)
    
    Write-Host "`n==> Building $($svc.Name)..." -ForegroundColor Cyan
    
    Push-Location $svc.Path
    try {
        # Build with Maven
        Write-Host "  Running mvn clean package..." -ForegroundColor Gray
        mvn clean package -DskipTests
        if ($LASTEXITCODE -ne 0) { throw "Maven build failed" }
        
        # Build Docker image
        Write-Host "  Building Docker image..." -ForegroundColor Gray
        docker build -t "${dockerUsername}/$($svc.Image):latest" .
        if ($LASTEXITCODE -ne 0) { throw "Docker build failed" }
        
        # Push to registry
        Write-Host "  Pushing to Docker Hub..." -ForegroundColor Gray
        docker push "${dockerUsername}/$($svc.Image):latest"
        if ($LASTEXITCODE -ne 0) { throw "Docker push failed" }
        
        Write-Host "  ✓ $($svc.Name) built and pushed successfully" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

function Build-Frontend {
    Write-Host "`n==> Building frontend..." -ForegroundColor Cyan
    
    Push-Location "frontend/chefathands-frontend"
    try {
        Write-Host "  Running npm install..." -ForegroundColor Gray
        npm install
        if ($LASTEXITCODE -ne 0) { throw "npm install failed" }
        
        Write-Host "  Running npm build..." -ForegroundColor Gray
        npm run build
        if ($LASTEXITCODE -ne 0) { throw "npm build failed" }
        
        # Create Dockerfile if it doesn't exist
        $dockerfileContent = @"
FROM nginx:alpine
COPY build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
"@
        Set-Content -Path "Dockerfile" -Value $dockerfileContent
        
        Write-Host "  Building Docker image..." -ForegroundColor Gray
        docker build -t "${dockerUsername}/chefathands-frontend:latest" .
        if ($LASTEXITCODE -ne 0) { throw "Docker build failed" }
        
        Write-Host "  Pushing to Docker Hub..." -ForegroundColor Gray
        docker push "${dockerUsername}/chefathands-frontend:latest"
        if ($LASTEXITCODE -ne 0) { throw "Docker push failed" }
        
        Write-Host "  ✓ Frontend built and pushed successfully" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

function Deploy-ToCluster {
    Write-Host "`n==> Deploying to Kubernetes cluster..." -ForegroundColor Cyan
    
    # Create namespace
    Write-Host "  Creating namespace..." -ForegroundColor Gray
    kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply manifests
    Write-Host "  Applying database secret..." -ForegroundColor Gray
    kubectl apply -f k8s/database-secret.yaml
    
    Write-Host "  Deploying services..." -ForegroundColor Gray
    kubectl apply -f k8s/ingredient-service.yaml
    kubectl apply -f k8s/user-service.yaml
    kubectl apply -f k8s/favourites-service.yaml
    kubectl apply -f k8s/history-service.yaml
    kubectl apply -f k8s/logging-service.yaml
    kubectl apply -f k8s/notification-service.yaml
    kubectl apply -f k8s/recipe-search-service.yaml
    kubectl apply -f k8s/recommendation-service.yaml
    kubectl apply -f k8s/frontend-gateway.yaml
    kubectl apply -f k8s/frontend.yaml
    kubectl apply -f k8s/ingress.yaml
    
    Write-Host "  Restarting deployments..." -ForegroundColor Gray
    kubectl rollout restart deployment -n $namespace
    
    Write-Host "  Waiting for rollout..." -ForegroundColor Gray
    kubectl rollout status deployment -n $namespace --timeout=5m
    
    Write-Host "`n==> Deployment Status:" -ForegroundColor Cyan
    kubectl get pods -n $namespace
    Write-Host ""
    kubectl get svc -n $namespace
    Write-Host ""
    kubectl get ingress -n $namespace
    
    Write-Host "`n✓ Deployment complete!" -ForegroundColor Green
}

# Main execution
Write-Host "ChefAtHands Deployment Script" -ForegroundColor Yellow
Write-Host "==============================`n" -ForegroundColor Yellow

if (-not $SkipBuild) {
    # Build services
    if ($Service -eq "all") {
        foreach ($svc in $services) {
            Build-Service $svc
        }
        Build-Frontend
    }
    elseif ($Service -eq "frontend") {
        Build-Frontend
    }
    else {
        $svc = $services | Where-Object { $_.Name -eq $Service }
        if ($svc) {
            Build-Service $svc
        }
        else {
            Write-Host "Unknown service: $Service" -ForegroundColor Red
            Write-Host "Available services: $($services.Name -join ', '), frontend" -ForegroundColor Yellow
            exit 1
        }
    }
}

if (-not $BuildOnly) {
    Deploy-ToCluster
}

Write-Host "`nDone!" -ForegroundColor Green
