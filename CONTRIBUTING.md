# Contributing Guidelines

Thank you for considering contributing to our project! We appreciate your interest and welcome any contributions you may have.

Please read through this document before submitting any issues or pull requests to ensure we have all the necessary information to effectively respond to your bug report or contribution.

## Sections

- [General Instructions](#general-instructions)
- [Local Setup Prerequisites](#local-setup-prerequisites)
- [Contribute to Backend](#contribute-to-backend)
- [Contribute to Frontend](#contribute-to-frontend)
- [Other Ways to Contribute](#other-ways-to-contribute)

## General Instructions

## For Pull Request(s)

Contributions via pull requests are much appreciated. Once the approach is agreed upon ✅, make your changes and open a Pull Request(s). Before sending us a pull request, please ensure that,

- Fork the repo on GitHub, clone it on your machine.
- Create a branch with your changes.
- You are working against the latest source on the `develop` branch.
- Modify the source; please focus only on the specific change.
- Ensure local tests pass.
- Commit to your fork using clear commit messages.
- Send us a pull request.
- Pay attention to any automated CI failures reported in the pull request.
- Stay involved in the conversation

⚠️ Please note: If you want to work on an issue, please ask the maintainers to assign the issue to you before starting work on it. This would help us understand who is working on an issue and prevent duplicate work. 🙏🏻

---

## Local Setup Prerequisites
  - The application currently supports **Node.js v18.x**.
  - `pnpm` packages manager, (from pnpm [guide](https://pnpm.io/installation) pick any installation method).

## Contribute to Backend

- Clone the `ledger` repository and `cd` into `ledger` directory.
- Create `.env` file by copying `.env.example` file to `.env`. (The ``.env.example`` file has all the necessary values of variables to start development directly).

```
cp .env.example .env
```

- Install all npm dependencies of the monorepo, you don't have to change directory to the `backend` package. just hit the command on root directory and it will install dependencies of all packages.

```
pnpm install
```

- Run all required docker containers in the development, we already configured all containers under `docker-compose.yml`.

```
export DOCKER_DEFAULT_PLATFORM=linux/amd64

docker-compose up -d
```

Wait some seconds, and hit `docker-compose ps` and you should see the same result below.

```
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS        PORTS                               NAMES
d974edfab9df   ledger-mysql   "docker-entrypoint.s…"   7 seconds ago   Up 1 second   0.0.0.0:3306->3306/tcp, 33060/tcp   ledger-mysql-1
cefa73fe2881   ledger-redis   "docker-entrypoint.s…"   7 seconds ago   Up 1 second   6379/tcp                            ledger-redis-1
1ea059198cb4   ledger-mongo   "docker-entrypoint.s…"   7 seconds ago   Up 1 second   0.0.0.0:27017->27017/tcp            ledger-mongo-1
```

- There're some CLI commands we should run before running the server like databaase migration, so we need to build the `server` app first.

```
pnpm run build:server
```

- Run the database migration for system database.

```
node packages/server/build/commands.js system:migrate:latest
```

And you should get something like that.

```
Batch 1 run: 6 migrations
```

- Next, start the webapp application.

```
pnpm run dev:server
```

**[`^top^`](#)**

----

## Contribute to Frontend

- Clone the `ledger` repository and cd into `ledger` directory.

```
git clone https://github.com/digitranslab/ledger.git && cd ledger
```

- Install all npm dependencies of the monorepo, you don't have to change directory to the `frontend` package. just hit that command and will install all packages across all application.

```
pnpm install
```

- Next, start the webapp application.

```
pnpm run dev:webapp
```

**[`^top^`](#)**

---

## Code Review

We welcome constructive criticism and feedback on code submitted by contributors. All feedback should be constructive and respectful, and should focus on the code rather than the contributor. Code review may include suggestions for improvement or changes to the code.

---

## Other Ways to Contribute

There are many other ways to get involved with the community and to participate in this project:

- Use the product, submitting GitHub issues when a problem is found.
- Help code review pull requests and participate in issue threads.
- Submit a new feature request as an issue.
- Help answer questions on forums such as Ledger Community Discord Channel.
- Tell others about the project on Twitter, your blog, etc.

**[`^top^`](#)**

Again, Feel free to ping us on [`#contributing`](https://discord.com/invite/c8nPBJafeb) on our Discord community if you need any help on this :)

Thank You!