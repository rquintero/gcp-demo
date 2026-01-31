# GCP Hackathon Project

This project contains the complete setup for a Hackathon project hosted on Google Cloud Platform.
It includes Infrastructure as Code (Terraform), a Spring Boot Backend, a NextJS Frontend, and Python Tools.

## Structure

- `infra/`: Terraform configuration for VPC, Cloud SQL, Cloud Run, GCS, and Vertex AI.
- `backend/`: Spring Boot application (Java 17).
- `frontend/`: NextJS application (Node 18).
- `python-tools/`: FastAPI application (Python 3.11).

## Prerequisites

- Google Cloud SDK (`gcloud`) installed and authenticated.
- Terraform >= 1.0.
    - To install Terraform on macOS, run:
      
      `brew tap hashicorp/tap`
      
      `brew install hashicorp/tap/terraform`.
- Docker (for building images locally).

## Getting Started

### 1. Infrastructure Setup

Navigate to the `infra` directory:

```bash
cd infra
terraform init
terraform plan
terraform apply
```

This will create:
- A VPC Network with Serverless connector.
- Cloud SQL Postgres instance.
- Service Accounts for each service.
- Cloud Run services (placeholders).

### 2. Build and Deploy Services

You will need to build the Docker images and push them to Google Artifact Registry (GAR) or Container Registry (GCR).

**Backend:**
```bash
cd backend
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/backend:latest .
gcloud auth configure-docker us-central1-docker.pkg.dev  
docker push us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/backend:latest
```

**Frontend:**
```bash
cd frontend
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/frontend:latest .
docker push us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/frontend:latest
```

**Python Tools:**
```bash
cd python-tools
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/pytools:latest .
docker push us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/pytools:latest
```

### 3. Update Cloud Run Services

After pushing the images, update the Cloud Run services created by Terraform to use your new images:

```bash
gcloud run deploy backend-service --image us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/backend:latest --region us-central1
gcloud run deploy frontend-service --image us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/frontend:latest --region us-central1
gcloud run deploy pytools-service --image us-central1-docker.pkg.dev/burner-ricquint2/hackathon-repo/pytools:latest --region us-central1
```

## Security

Service-to-service communication is secured via IAM.
- Frontend SA -> Invokes Backend.
- Backend SA -> Invokes Python Tools.
- Backend/Python SAs -> Access Cloud SQL & Vertex AI.

## Development

- **Backend**: `mvn spring-boot:run`
- **Frontend**: `npm run dev`
- **Python**: `uvicorn main:app --reload`
