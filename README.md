# Platform Engineering Bootcamp Pocket IDP

## Workshop Overview

Welcome to the Platform Engineering Bootcamp Workshop at FLO 2024 in Gurgaon! This hands-on workshop focuses on building
a practical Internal Developer Platform (IDP) using Backstage and Humanitec.

In this workshop, you'll:

- Build a fully functional IDP from scratch
- Learn platform engineering fundamentals
- Work with Backstage as a Platform Portal
- Use Humanitec for platform orchestration
- Implement Score framework for K8s and Terraform management

The workshop combines both theory and hands-on practice, ensuring you leave with:

- A working local IDP implementation
- Understanding of platform engineering principles
- Practical experience with industry-standard tools

## Repository Structure

```
.
├── README.md
├── Taskfile.yml                # Task definitions for common operations
├── backstage/                  # Backstage portal configuration
├── scripts/                    # Installation and setup scripts
│   ├── 0_install.sh
│   ├── 1_demo.sh
│   └── 2_cleanup.sh
└── resources/                  # Resource definitions and templates
```

## Prerequisites

- Docker Desktop (or equivalent container runtime)
- [humctl CLI](https://developer.humanitec.com/platform-orchestrator/cli/)
- [Task](https://taskfile.dev/#/installation) - Task runner tool
- Humanitec Organization (details below)
- Administrator access to your Humanitec Organization

### Getting a Humanitec Organization

1. Sign up for a [free Humanitec trial](https://humanitec.com/free-trial)
2. After registration, navigate to your Organization Settings
3. Go to "Access Tokens" section
4. Create a new token with "Administrator" permissions
5. Save the token securely - you'll need it for setup

### Local Development Setup

1. Clone the Backstage repository:
   ```bash
   git clone https://github.com/Nagarro-Platform-Engineering/backstage.git
   ```

2. Install Task (if not already installed):
   ```bash
   # macOS
   brew install go-task

   # Linux
   sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin

   # Windows (with scoop)
   scoop install task
   ```

### Using Taskfile

The repository includes a Taskfile.yml for common operations:

```bash
# List all available tasks
task --list

# Commands:

task build         # Build the 5min-idp image
task check-image   # Check the 5min-idp image
task lint          # Lint terraform directory
task lint-init     # Initialize tflint
task push          # Push the 5min-idp image
task run-local     # Run the locally built image
task test          # Test the 5min-idp
```

## Setup Steps

1. **Login to CLI**
   ```bash
   humctl login
   ```

2. **Set Organization Environment Variable**
   ```bash
   export HUMANITEC_ORG=<my-org-id>   # Use lowercase org ID
   ```

3. **Start the Dev Container**
   ```bash
   docker run --rm -it -h 5min-idp --name 5min-idp --pull always \
    -e "HUMANITEC_ORG=$HUMANITEC_ORG" \
    -v hum-5min-idp:/state \
    -v $HOME/.humctl:/root/.humctl \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --network bridge \
    ghcr.io/humanitec-tutorials/5min-idp
   ```

4. **Install IDP Components**
   ```bash
   ./0_install.sh
   ```

5. **Deploy Demo Workload**
   ```bash
   ./1_demo.sh
   ```
   Wait for the URL endpoint to become available. You'll see a message like:
   ```bash
   Workload available at: http://5min-idp-abcd.localhost:30080
   ```

6. **Access the Workload**
   Open the provided URL in your browser to see the "Hello World!" message.

## Cleanup

1. **Remove Platform Objects**
   ```bash
   ./2_cleanup.sh
   ```

2. **Exit Container**
   ```bash
   exit
   ```

3. **Clean Docker Environment**
   ```bash
   docker image rm ghcr.io/humanitec-tutorials/5min-idp
   docker volume rm hum-5min-idp
   ```

## Troubleshooting

If you see this error:

```bash
ERROR: could not locate any control plane nodes for cluster named '5min-idp'
```

Follow these steps:

1. Exit the container (`exit`)
2. Remove the volume (`docker volume rm hum-5min-idp`)
3. Start over from the "Start the Dev Container" step

## What's Happening Behind the Scenes?

This setup:

1. Creates a dev container with required tooling
2. Launches a Kubernetes cluster using kind
3. Creates an Application in Platform Orchestrator
4. Sets up Resource Definitions for cluster access and PostgreSQL
5. Configures Humanitec Agent for secure communication
6. Deploys a sample workload with database connectivity

For more details, check out
the [Five-minute IDP guide](https://developer.humanitec.com/introduction/getting-started/the-five-minute-idp/) in the
Humanitec documentation.

# Local Development Setup

## 🛠️Project Tooling Setup Guide

### Ensure you have the following tools installed and configured before proceeding:

- **taskfile**: A task runner and build tool that allows you to define tasks in a simple file. Install instructions can
  be found [here](https://taskfile.dev/#/installation).

- **pre-commit**: A framework for managing and maintaining multi-language pre-commit hooks. Install instructions can be
  found [here](https://pre-commit.com/#install).

- **gitleaks**: A SAST tool for detecting hardcoded secrets like passwords, API keys, and tokens in git repositories.
  Install instructions can be found [here](https://github.com/gitleaks/gitleaks#installing).

- **terraform**: Terraform for infrastructure provisioning. Install instructions can be
  found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

- **tflint**: Terraform linter for identifying errors and potential issues. Install instructions can be
  found [here](https://github.com/terraform-linters/tflint#installation).

- **terraform-docs**: Generate documentation from Terraform modules. Install instructions can be
  found [here](https://github.com/terraform-docs/terraform-docs#installation).

- **terratest**: Terraform testing framework for automated testing. Install instructions can be
  found [here](https://terratest.gruntwork.io/docs/getting-started/quick-start/).

- **checkov**: Infrastructure as code static analysis tool for security and compliance scanning. Install instructions
  can be found [here](https://www.checkov.io/2.Basics/Installing%20Checkov.html).

#### Activating Pre-commit Hooks in your Local Repository

**Activating Pre-commit in the Repository**

1. **Install Pre-commit**: Install instructions can be
   found [here](https://pre-commit.com/#install).

2. **Initialize Pre-commit**: Run the following command to initialize Pre-commit in your local repository:

   ```bash
   pre-commit install --hook-type commit-msg
   ```
   Note: This command creates a `.git/hooks/pre-commit` script that runs the Pre-commit hooks defined in the
   `.pre-commit-config.yaml` file.

3. **Commit Changes**: Once Pre-commit is installed and initialized, commit your changes as usual using Git. Pre-commit
   will automatically run the configured hooks before each commit.
   If you want to run the hooks manually, you can use the following command:

   ```bash
   pre-commit run --all-files
   ```

   If you want to disable the hooks for a single commit, you can use the following command:

   ```bash
    git commit --no-verify
   ```

4. **Updating Pre-commit Hooks**: Periodically update Pre-commit hooks to ensure that you're using the latest versions
   of the tools and scripts. Run the following command to update the hooks:

   ```
   pre-commit autoupdate
   ```