# Senior DevOps Engineer Task Implementation

## Table of Contents
1. [Overview](#overview)
2. [Original Task Requirements](#original-task-requirements)
3. [Adaptation to Oracle Cloud](#adaptation-to-oracle-cloud)
4. [Demo](#demo)
5. [Solution Architecture](#solution-architecture)
6. [Infrastructure as Code Implementation](#infrastructure-as-code-implementation)
7. [Application Implementation](#application-implementation)
8. [CI/CD Pipeline](#cicd-pipeline)
9. [Monitoring and Logging](#monitoring-and-logging)
10. [Security Measures](#security-measures)
11. [Scalability and Resiliency](#scalability-and-resiliency)
12. [Future Improvements](#future-improvements)
13. [Conclusion](#conclusion)

## Overview

This project demonstrates the implementation of a simple HTTP service as requested in the Senior DevOps Engineer hiring task. Due to the unavailability of an Azure subscription or free tier, the solution has been adapted to use Oracle Cloud Infrastructure (OCI) Free Tier while still adhering to the core principles and requirements of the original task.

## Original Task Requirements

The original task required the following:

1. Create a simple HTTP service with a `/live` endpoint
2. Design and deploy the application as a cloud solution, preferably in Azure
3. Use Infrastructure as Code (IaC), preferably Terraform, to create the cloud components and database
4. Implement solutions that support scalability, resiliency, and security
5. Provide configuration file(s) that define resources and network
6. Add basic logging/monitoring capabilities
7. Apply a CI/CD solution (preferably Azure DevOps)
8. Provide basic documentation and an architecture diagram

## Adaptation to Oracle Cloud

Due to the unavailability of an Azure subscription, the solution was implemented using Oracle Cloud Infrastructure (OCI) Free Tier. However, to demonstrate proficiency with Azure, Terraform modules for Azure resources were created alongside the OCI implementation. This approach showcases the ability to work with multiple cloud providers and adapt to different environments.

## Demo

The application is accessible at: https://kimohesh.us.to/live

The `/live` endpoint demonstrates the required functionality:
- Returns "Well done" when successfully connected to the database
- Returns "Maintenance" when there are database connection issues

## Solution Architecture

The implemented solution consists of the following components:

1. **Infrastructure**: Oracle Cloud Infrastructure (OCI) Free Tier
   - Compute Instance: Running the application and Nginx
   - Virtual Cloud Network (VCN): Network isolation and security
   - Object Storage: For storing logs and backups
   - Autonomous Database: PostgreSQL-compatible database

2. **Web Server**: Nginx
   - Acts as a reverse proxy and load balancer
   - Handles SSL/TLS termination

3. **Application**: Simple HTTP API with a `/live` endpoint
   - Implemented using Node.js and Express.js
   - Connects to the OCI Autonomous Database

4. **Containerization**: Docker and Docker Compose
   - Application and Nginx are containerized
   - Easy scaling and deployment management

5. **Infrastructure as Code**: Terraform with Terragrunt
   - Manages OCI resources
   - Includes Azure modules for demonstration purposes

6. **CI/CD**: GitHub Actions
   - Automated build, test, and deployment pipeline

## Infrastructure as Code Implementation

### Terraform with Terragrunt Structure

The infrastructure is organized using a modular approach with Terragrunt for better code reuse and management. While the modules are designed for Azure, they demonstrate the architecture and best practices that would be used in a production environment.

