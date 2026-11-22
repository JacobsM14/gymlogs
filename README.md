# Gymlogs

Gymlogs was my final project for the Higher National Diploma in Web Application Development (*Grado Superior de Desarrollo de Aplicaciones Web*). It is no longer online, since it has been replaced by its new version, [Fort](https://fort.marcel14.dev/).

This repository is kept as a record of the project and as a way to point out, as a self-review, the mistakes I made back then.

## Background and design decisions

The assignment was a website (it could not be a mobile app) with a working frontend and backend. Unlike my classmates, I had to build this project on my own, which limited my time and hurt the final result. Even so, several classmates helped me by teaching me things I didn't know — I thanked them back then and I'm still grateful.

At the time I had no idea about React or APIs; this was my first contact with both. Today I have almost two years of professional experience with React at Apex World, where I build a gamified CRM for NGO fundraising.

The code will be annotated (work in progress) with comments explaining the mistakes I made and what I would do differently now. I'm not going to fix them: now that Fort exists, it doesn't seem necessary.

## Mistakes visible at first glance

- **Commit history:** the commits in both the original backend and frontend repositories are TERRIBLE.
- **No real authentication:** there is no JWT or session token. After logging in, the frontend stores the user's ID as the `token` cookie and their role in a `userRole` cookie, and the backend trusts them. Bypassing security was trivial: knowing the admin user's ID was enough to get admin access.
- **Password handling:** the login endpoint returns the plain-text password in its response, and the frontend logs the email and password to the browser console.
- **Poor use of React hooks.**
- **No ORM or migrations:** the database tables are created from a raw SQL file. An ORM such as Drizzle or Prisma would provide a typed schema and versioned migrations.
- **No TypeScript and no validation:** there are no types for the data sent to or received from the API, and nothing validates it at runtime. TypeScript plus a schema validator like Zod would ensure the data has the expected shape and types.
- **`.env` committed:** the frontend's `.env` file was committed to the repository.
- **No Tailwind:** styling is spread across too many CSS files.
- **Login when the backend is down:** if the backend doesn't respond and you click "Log in", it takes you straight into the app.

## What I've added to this repository

- Merged the two original repositories (frontend and backend) into a single one.
- A `justfile` to run everything with a single command.
- A `docker-compose.yml` in the backend that runs the MySQL database it needs, initialised from `backend/sql/databse.sql`. It was needed to start reviewing the project.
- A `.env.example` in the backend.

## Running it locally

Requirements: [Bun](https://bun.sh/), [Docker](https://www.docker.com/) and [just](https://github.com/casey/just).

```bash
cp backend/.env.example backend/.env
just install   # install backend and frontend dependencies
just dev       # start MySQL (Docker), then the backend and the frontend
```

- Backend: <http://localhost:3001>
- Frontend: the URL Vite prints (by default <http://localhost:5173>)

Other recipes: `just db`, `just backend`, `just frontend`, `just down` and `just reset-db` (deletes the database so it is recreated from the SQL file). Run `just` to list them all.
