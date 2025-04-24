# Platform Engineering Bootcamp Pocket IDP

A practical Internal Developer Platform (IDP) using Backstage and Humanitec, created for the Platform Engineering
Bootcamp Workshop at FLO 2024 based on the ["Five-minute IDP"](https://developer.humanitec.com/introduction/getting-started/the-five-minute-idp/) getting started guide in the Humanitec developer docs.

## Table of Contents

- [Platform Engineering Bootcamp Pocket IDP](#platform-engineering-bootcamp-pocket-idp)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
  - [Available Tasks](#available-tasks)
  - [Prerequisites](#prerequisites)
  - [Repository Structure](#repository-structure)
  - [Detailed Documentation](#detailed-documentation)
  - [Local Development Setup](#local-development-setup)
  - [TLS Certificate Management](#tls-certificate-management)
  - [Environment Configuration](#environment-configuration)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)
  - [License](#license)

## Quick Start

0. **Create a free Humanitec account**
   [Humanitec Free Trial](https://humanitec.com/free-trial).

1. **Install Prerequisites**

   ```bash
   # macOS
   brew install go-task mkcert
   brew install humanitec/tap/cli

   # Linux
   sudo apt install mkcert
   sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
   
   # Install humctl (Linux/macOS)
   curl -L "https://cli.humanitec.io/linux_x86_64" | tar xz
   sudo mv humctl /usr/local/bin
   ```

2. **Setup Humanitec**

   ```bash
   # Login to Humanitec
   humctl login

   # Set your organization ID (automatically from humctl)
   export HUMANITEC_ORG="$(humctl get organization -o yaml | yq '.[0].metadata.id')"
   ```

3. **Setup Environment**

   ```bash
   # Generate certificates
   task generate-certs

   # Create and configure environment file
   task generate-env
   ```

4. **Run the IDP**

   ```bash
   task run-local
   ```

   ```bash
   docker run --rm -it -h pocketidp --name 5min-idp \
       -e HUMANITEC_ORG \
       -e HUMANITEC_SERVICE_USER \
       -e TLS_CA_CERT \
       -e TLS_CERT_STRING \
       -e TLS_KEY_STRING \
       -v hum-5min-idp:/state \
       -v $HOME/.humctl:/root/.humctl \
       -v /var/run/docker.sock:/var/run/docker.sock \
       --network bridge \
       kheimel/pocket-idp:latest
   ```

5. **Run the installation script inside the container**

   ```bash
   0_install.sh
   docker exec mycontainer 0_install.sh
   ```

   This script will:
    - Set up a local Kind cluster
    - Configure a local container registry
    - Install and configure Gitea with a runner for CI/CD
    - Set up Backstage with Humanitec integration
    - Configure TLS certificates and networking

> 🗒️ Note:
> This script takes at least 5 minutes to complete.

6. **Deploy the Demo Application** (Optional)

   To deploy a sample application that demonstrates the platform capabilities:
   ```bash
   1_demo.sh
   docker exec mycontainer 1_demo.sh
   ```

   This will:
    - Create a sample microservices application
    - Set up CI/CD pipelines in Gitea
    - Deploy the application through Humanitec
    - Configure Backstage to display the application

7. **Cleanup Resources**

   When you're done, you can clean up all resources:
   ```bash
   2_cleanup.sh
   docker exec mycontainer 2_cleanup.sh
   ```

   This script will:
    - Remove the Kind cluster
    - Clean up local container registry
    - Remove deployed applications
    - Delete local certificates and configurations

8. **Access Your Resources**

   Export your kubeconfig to interact with the local cluster:
   ```bash
   task export-kubeconfig
   ```

   You can now:
    - Visit your [Humanitec Dashboard](https://app.humanitec.io) to see the deployed resources
    - Use `kubectl` to interact with your local cluster
    - Access Backstage through the configured endpoint

9. **Sign in to your local Gitea instance**

   Gitea is a self-hosted Git service replicating GitHub. It is used to host the repository for the demo application.

   [git.localhost:30443](http://git.localhost:30443)

   ![Gitea Login](./assets/gitea-login.png)

   Login with the following credentials:
   - Username: `5minadmin`
   - Password: `5minadmin`

## Available Tasks

```bash
task --list

# Common commands:
task run-local      # Run the IDP locally
task generate-certs  # Generate TLS certificates for local development
task generate-env    # Create template .env file with required variables
task verify-env      # Check if all required variables are set
task build          # Build the container image
task push           # Push the container image to the registry
task test           # Run test suite
```

## Prerequisites

- Docker Desktop (or equivalent)
- [Task](https://taskfile.dev/#/installation) - Task runner
- [mkcert](https://github.com/FiloSottile/mkcert) - Local certificate authority
- [Humanitec Account](https://humanitec.com/free-trial) - Platform orchestration

## Repository Structure

```txt
.
├── README.md
├── Taskfile.yml                # Task definitions
├── backstage/                  # Backstage configuration
├── scripts/                    # Setup scripts
└── resources/                  # Resource templates
```

## Detailed Documentation

- [Platform Engineering Bootcamp Pocket IDP](#platform-engineering-bootcamp-pocket-idp)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
  - [Available Tasks](#available-tasks)
  - [Prerequisites](#prerequisites)
  - [Repository Structure](#repository-structure)
  - [Detailed Documentation](#detailed-documentation)
  - [Local Development Setup](#local-development-setup)
  - [TLS Certificate Management](#tls-certificate-management)
  - [Environment Configuration](#environment-configuration)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)
  - [License](#license)

## Local Development Setup

[Previous detailed setup content...]

## TLS Certificate Management

[Previous TLS content...]

## Environment Configuration

[Previous environment variable content...]

## Troubleshooting

[Previous troubleshooting content...]

## Contributing

1. Install pre-commit hooks:
   ```bash
   pre-commit install --hook-type commit-msg
   ```

2. Run tests before submitting PRs:
   ```bash
   task test
   ```

## License

[Add license information]


## Backstage Workshop Deployment

This repository contains Score YAML files to deploy a Backstage instance and a sample app on a local Kubernetes cluster for workshop purposes.

## Prerequisites

- A local Kubernetes cluster (e.g., Minikube or Kind)
- `kubectl` configured to access your cluster
- Score CLI installed (`npm install -g @score-spec/score-cli`)
- Helm (for Score humanitec integration, optional)


1. Install Score CLI (if not already installed):

2. Deployment
   Deploy Backstage
```
   Generate Kubernetes manifests:
   score compose -f score-files/backstage-score.yaml > backstage-manifests.yaml
```
```
   kubectl apply -f backstage-manifests.yaml
```
3. Access Backstage:
```
   kubectl port-forward svc/backstage-workshop 7007:80
   Open http://localhost:7007 in your browser.
```

## Use Colima to Run Docker Containers on macOS
which you can do by following the Install Homebrew tutorial.

## Uninstalling Docker for Mac
Before moving forward, you’ll want to remove the existing Docker for Mac application if you have it running. Unfortunately, this process will remove all of your containers as well as your images. You’ll have to rebuild your local images and re-download any upstream images again.

To uninstall Docker for Mac, right-click on the Docker icon in your task bar, select Troubleshooting, and then select Uninstall. This process will warn you that it will remove all of your containers and images, and will then perform the uninstall process. At the end, the Docker for Mac application will exit.

Once it’s completed, you can install Colima.

## Installing Colima and Docker’s CLI with Homebrew without Docker License
The fastest way to get Colima installed is through Homebrew.

```
brew install colima
```
Once Colima installs, install Docker and Docker Compose.

```
brew install docker docker-compose
```
Then configure docker-compose as a Docker plugin so you can use docker compose as a command instead of the legacy docker-compose script. First, create a folder in your home directory to hold Docker CLI plugins:

```
mkdir -p ~/.docker/cli-plugins
```
Then symlink the docker-compose command into that new folder:

```
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```
Run docker compose:

```
docker compose
```
```
brew install docker-Buildx
```
Once downloaded, symlink it to the cli-plugins folder:

```
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
```
With the commands installed, you can start Colima and work with containers

## Using Colima to Run Images
You installed colima, but it isn’t running yet. Colima works by using a virtual machine to run containers, which is similar to how DOcker for Mac works. On the first run, Colima will download and configure a virtual machine to run the containers. This virtual machine has 2 CPUs, 2GiB memory and 60GiB storage, which should be enough for moderate use. You can change the memory size and number of virtual CPUs at any time.

Start Colima with the following command:

```
colima start
```# workshop

## Deployend Backstage and ArgoCD 

k -n argocd port-forward svc/argocd-server 8080:80

k -n backstage port-forward svc/backstage 7007:7007