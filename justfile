backend := "GYMLOGS_BACKEND"
frontend := "GYMLOGS_FRONTEND"
compose := "docker compose -f " + backend + "/docker-compose.yml"

default:
    @just --list

# Instala dependencias de backend y frontend
install:
    cd {{backend}} && bun install
    cd {{frontend}} && bun install

# Arranca MySQL (Docker) y luego backend + frontend a la vez
dev: db
    #!/usr/bin/env bash
    set -euo pipefail
    trap 'kill 0' EXIT
    (cd {{backend}} && bun --watch run index.js) &
    (cd {{frontend}} && bun run dev) &
    wait

# Solo el backend
backend: db
    cd {{backend}} && bun --watch run index.js

# Solo el frontend
frontend:
    cd {{frontend}} && bun run dev

# Levanta MySQL en Docker y espera a que esté listo
db:
    {{compose}} up -d --wait

# Para MySQL
down:
    {{compose}} down

# Borra la base de datos (se recrea desde sql/databse.sql al volver a arrancar)
reset-db:
    {{compose}} down -v
