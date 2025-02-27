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
   brew install go-task mkcert kumactl

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
       kheim/pocketidp:latest
   ```

5. **Run the installation script inside the container**

   ```bash
   0_install.sh
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
