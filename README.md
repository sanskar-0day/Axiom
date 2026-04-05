# Axiom

Axiom is an ambitious project aimed at creating a cohesive, reproducible, and highly customized computing environment. It currently encompasses both a frontend web interface and a vision for a custom Nix-based operating system.

## 🚀 Project Vision

The goal of Axiom is to merge high-level aesthetics with low-level system reproducibility. 

- **Axiom OS**: A planned NixOS-based distribution using Flakes to ensure that the entire system configuration—from kernel parameters to desktop environment—is version-controlled and reproducible across any machine.
- **Axiom Web**: A SvelteKit-powered interface designed to serve as the visual or administrative layer of the Axiom ecosystem.

## 📂 Project Structure

```text
Axiom/
├── app/
│   └── web/          # SvelteKit web application
└── (OS config)       # Planned NixOS configuration (flake.nix, etc.)
```

## 💻 Axiom Web

The web component is a modern frontend built with **SvelteKit**, **Vite**, and **GSAP** for high-performance animations.

### Prerequisites

- [Bun](https://bun.sh) (Required for dependency management and runtime)

### Running the Web App

Navigate to the web directory:
```bash
cd app/web
```

Use the provided `run.sh` script for various modes:

- **Development Preview**:
  ```bash
  ./run.sh preview
  ```
  Starts the server on `http://localhost:4200`.

- **Production Build**:
  ```bash
  ./run.sh build
  ```

- **External Broadcast**:
  ```bash
  ./run.sh broadcast
  ```
  Starts the server and automatically initializes a Cloudflare Tunnel to make the site accessible via a public URL.

## ❄️ Axiom OS (Planned)

The OS layer will be implemented using **NixOS Flakes**. This will allow for:
- Declarative system configuration.
- Atomic updates and easy rollbacks.
- Modular configuration split into hardware, users, and application sets.

---
*Axiom: Redefining the intersection of system architecture and user experience.*
