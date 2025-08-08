# Automated CI/CD Pipeline for Containerized Web Application on AWS

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Infrastructure Setup](#infrastructure-setup)
- [Application Components](#application-components)
- [Deployment Pipeline](#deployment-pipeline)
- [Security Considerations](#security-considerations)
- [Monitoring and Logging](#monitoring-and-logging)
- [Getting Started](#getting-started)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Project Overview

This project implements a fully automated CI/CD pipeline for deploying a containerized web application on AWS. The system leverages modern DevOps practices including Infrastructure as Code (IaC), containerization, and automated testing to ensure reliable, scalable, and secure deployments.

### Key Features
- **Automated Infrastructure Provisioning**: Complete AWS infrastructure managed with Terraform
- **Containerized Deployment**: Docker-based application packaging and deployment
- **Blue-Green Deployment Strategy**: Zero-downtime deployments using AWS ECS
- **Comprehensive Monitoring**: CloudWatch integration with centralized logging
- **Security First**: Automated security scanning and vulnerability assessments
- **Scalable Architecture**: Auto-scaling capabilities with load balancing

## Architecture

### High-Level Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Developer     │───▶│   Jenkins       │───▶│   AWS ECS       │
│   Git Push      │    │   CI/CD         │    │   Container     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                               │
                               ▼
                    ┌─────────────────┐
                    │   AWS ECR       │
                    │   Container     │
                    │   Registry      │
                    └─────────────────┘
```

### Infrastructure Components
- **VPC**: Isolated network environment with public and private subnets
- **ECS Cluster**: Managed container orchestration platform
- **Application Load Balancer**: Traffic distribution and health checks
- **ECR Repository**: Private Docker image registry
- **CloudWatch**: Monitoring, logging, and alerting
- **EC2 Instance**: Jenkins CI/CD server

## Technologies Used

### Core Technologies
- **AWS ECS (Fargate)**: Container orchestration
- **Docker**: Application containerization
- **Jenkins**: Continuous Integration/Continuous Deployment
- **Terraform**: Infrastructure as Code
- **Nginx**: Web server and reverse proxy

### AWS Services
- **Amazon ECS**: Container management service
- **Amazon ECR**: Container registry
- **Amazon VPC**: Virtual Private Cloud
- **Amazon CloudWatch**: Monitoring and logging
- **AWS IAM**: Identity and Access Management
- **Amazon EC2**: Virtual servers

### Development Stack
- **HTML5/CSS3**: Frontend markup and styling
- **JavaScript (ES6+)**: Client-side interactivity
- **Font Awesome**: Icon library
- **Responsive Design**: Mobile-first approach

## Prerequisites

### Required Tools
- AWS CLI (v2.0+)
- Terraform (v1.0+)
- Docker (v20.0+)
- Git (v2.0+)
- Jenkins (v2.400+)

### Required Permissions
- AWS IAM user with administrative access
- ECR repository access
- ECS cluster management permissions
- CloudWatch logging permissions

### Environment Setup
```bash
# AWS CLI configuration
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set default.region ap-south-1

# Verify Docker installation
docker --version

# Verify Terraform installation
terraform --version
```

## Infrastructure Setup

### 1. Terraform Infrastructure

The infrastructure is defined using Terraform modules for better organization and reusability.

#### Core Infrastructure Components

**VPC Configuration (`infrastructure/ec2.tf`)**
- VPC with CIDR block 10.0.0.0/16
- Public subnets for internet-facing resources
- Private subnets for internal services
- Internet Gateway for external connectivity
- Route tables for traffic management

**Container Registry (`infrastructure/ecr.tf`)**
- ECR repository for Docker images
- Image scanning configuration
- Repository policies for access control

**Container Orchestration (`infrastructure/ecs.tf`)**
- ECS cluster with Fargate launch type
- Task definitions with resource allocation
- Service configuration with desired count
- Security groups for network access control

### 2. Deployment Commands

```bash
# Initialize Terraform
cd infrastructure/
terraform init

# Plan infrastructure changes
terraform plan

# Apply infrastructure
terraform apply -auto-approve

# Destroy infrastructure (when needed)
terraform destroy -auto-approve
```

### 3. Output Values
After successful deployment, Terraform provides:
- VPC ID
- ECR Repository URL
- ECS Cluster Name
- ECS Service Name

## Application Components

### Frontend Application

**Structure**
```
app/
├── public/
│   ├── index.html      # Main HTML structure
│   ├── style.css       # Responsive CSS styling
│   └── script.js       # Interactive JavaScript
```

**Key Features**
- **Responsive Design**: Mobile-first approach with CSS Grid and Flexbox
- **Interactive Dashboard**: Real-time status monitoring
- **Health Checks**: Automated application health verification
- **Log Viewing**: Integrated log management interface
- **Modern UI/UX**: Contemporary design with animations and effects

### Docker Configuration

**Dockerfile**
```dockerfile
FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY app/public/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Features**
- Lightweight Nginx base image
- Optimized for production deployment
- Single-layer application copy
- Port 80 exposure for HTTP traffic

## Deployment Pipeline

### Jenkins Pipeline Configuration

The CI/CD pipeline is defined in `jenkins/Jenkinsfile` with the following stages:

#### 1. Checkout Code
- Pulls latest code from the main branch
- Ensures clean working directory

#### 2. Build & Test
- Builds Docker image with versioned tags
- Runs local container for testing
- Performs health checks

#### 3. ECR Authentication
- Authenticates with AWS ECR
- Handles temporary credentials securely

#### 4. Image Push
- Pushes built image to ECR repository
- Tags with build number for traceability

#### 5. ECS Deployment
- Updates ECS service configuration
- Forces new deployment for zero-downtime updates
- Monitors deployment status

### Pipeline Environment Variables
```groovy
environment {
    ECR_REPO    = '442042536659.dkr.ecr.ap-south-1.amazonaws.com/cicd-demo'
    IMAGE_TAG   = "v1.${BUILD_NUMBER}"
    ECS_CLUSTER = 'cicd-demo-cluster'
    ECS_SERVICE = 'cicd-demo-service'
}
```

### Deployment Strategy
- **Blue-Green Deployment**: Ensures zero-downtime deployments
- **Health Checks**: Automated verification before traffic routing
- **Rollback Capability**: Quick rollback to previous stable version
- **Gradual Rollout**: Progressive deployment with monitoring

## Security Considerations

### Infrastructure Security
- **VPC Isolation**: Network-level segregation
- **Security Groups**: Restrictive ingress/egress rules
- **IAM Roles**: Least privilege access principle
- **Private Subnets**: Internal services isolation

### Container Security
- **Image Scanning**: Automated vulnerability detection
- **Base Image Updates**: Regular security patches
- **Secrets Management**: Environment-based configuration
- **Network Policies**: Container communication restrictions

### Application Security
- **HTTPS Enforcement**: SSL/TLS termination at load balancer
- **Security Headers**: CORS, CSP, and security headers
- **Input Validation**: Client and server-side validation
- **Dependency Scanning**: Regular dependency updates

## Monitoring and Logging

### CloudWatch Integration
- **Container Insights**: ECS cluster and service metrics
- **Log Aggregation**: Centralized application logging
- **Custom Metrics**: Application-specific monitoring
- **Alarms**: Automated alerting for threshold breaches

### Log Management
- **Structured Logging**: JSON-formatted log entries
- **Log Retention**: Configurable retention policies
- **Log Analysis**: CloudWatch Logs Insights queries
- **Real-time Monitoring**: Live log streaming

### Performance Monitoring
- **Resource Utilization**: CPU, memory, and network metrics
- **Response Time**: Application performance tracking
- **Error Rates**: Error tracking and alerting
- **Capacity Planning**: Resource usage trends

## Getting Started

### 1. Clone Repository
```bash
git clone https://github.com/UjwalNagrikar/Automated-CI-CD-Pipeline-for-Containerized-Web-Application-on-AWS.git
cd Automated-CI-CD-Pipeline-for-Containerized-Web-Application-on-AWS
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key  
# Default region: ap-south-1
# Default output format: json
```

### 3. Deploy Infrastructure
```bash
cd infrastructure/
terraform init
terraform plan
terraform apply
```

### 4. Configure Jenkins
1. Access Jenkins at `http://[EC2-PUBLIC-IP]:8080`
2. Complete initial setup wizard
3. Install required plugins:
   - AWS Pipeline Plugin
   - Docker Pipeline Plugin
   - Git Plugin
4. Configure AWS credentials in Jenkins
5. Create new pipeline job with GitHub repository

### 5. Trigger Deployment
- Push code changes to main branch
- Jenkins automatically triggers pipeline
- Monitor deployment progress in Jenkins console
- Verify application at ECS service endpoint

## Troubleshooting

### Common Issues

**1. ECR Authentication Failed**
```bash
# Solution: Refresh ECR login
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin [ECR_REPO_URL]
```

**2. ECS Service Deployment Stuck**
```bash
# Check service events
aws ecs describe-services --cluster cicd-demo-cluster --services cicd-demo-service

# Check task definition
aws ecs describe-task-definition --task-definition cicd-demo
```

**3. Container Health Check Failures**
- Verify container port configuration
- Check security group rules
- Review application logs in CloudWatch

**4. Terraform State Issues**
```bash
# Refresh Terraform state
terraform refresh

# Import existing resources if needed
terraform import aws_instance.my_server [INSTANCE_ID]
```

### Debugging Commands
```bash
# Check Docker container logs
docker logs my-app

# Verify ECS service status
aws ecs describe-services --cluster cicd-demo-cluster --services cicd-demo-service

# Monitor CloudWatch logs
aws logs tail /ecs/cicd-demo --follow
```

## Performance Optimization

### Container Optimization
- Multi-stage Docker builds for smaller images
- Layer caching for faster builds
- Resource limits and requests optimization
- Health check tuning

### Infrastructure Optimization
- Auto Scaling Groups for dynamic scaling
- Application Load Balancer optimization
- CloudFront CDN integration
- Database connection pooling

### Application Optimization
- Static asset optimization
- Code splitting and lazy loading
- Caching strategies
- Performance monitoring integration

## Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Code Standards
- Follow conventional commit messages
- Maintain test coverage above 80%
- Use meaningful variable and function names
- Document complex logic and configurations

### Testing Guidelines
- Unit tests for business logic
- Integration tests for API endpoints
- End-to-end tests for critical user journeys
- Infrastructure tests with Terratest

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

**Project Maintainer**: Ujwal Nagrikar  
**Repository**: [GitHub](https://github.com/UjwalNagrikar/Automated-CI-CD-Pipeline-for-Containerized-Web-Application-on-AWS)

For questions and support, please open an issue in the GitHub repository.

---

*This documentation is maintained as part of the CI/CD pipeline and is automatically updated with each release.*
