# NemoClaw Docker Wrapper

This repo provides a Dockerized way to run NVIDIA NemoClaw (`nemoclaw`) without installing it directly on your host.

## What this container includes

- Node.js 22
- `nemoclaw` CLI (installed from `NVIDIA/NemoClaw` source)
- `openshell` CLI (downloaded from NVIDIA OpenShell releases)
- Docker CLI (container talks to your host Docker daemon via mounted socket)

## Prerequisites

- Docker running on the host
- NVIDIA API key from `build.nvidia.com` (for onboarding and inference)

## Build

```bash
docker compose build
```

Optional: pin OpenShell release and NemoClaw ref at build time:

```bash
OPENSHELL_VERSION=v0.10.0 NEMOCLAW_REF=main docker compose build
```

## Run NemoClaw onboarding

```bash
export NVIDIA_API_KEY=nvapi-...
docker compose run --rm nemoclaw nemoclaw onboard
```

## Useful commands

```bash
docker compose run --rm nemoclaw nemoclaw --help
docker compose run --rm nemoclaw nemoclaw list
docker compose run --rm nemoclaw nemoclaw <sandbox-name> status
docker compose run --rm nemoclaw openshell status
```

## Notes

- The container uses `network_mode: host` and mounts `/var/run/docker.sock` so NemoClaw/OpenShell can control host containers.
- NemoClaw state is persisted in named volumes:
  - `nemoclaw_registry` (`/root/.nemoclaw`)
  - `openclaw_config` (`/root/.openclaw`)
  - `openshell_config` (`/root/.config/openshell`)
