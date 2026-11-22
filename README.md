# Gymlogs

Gymlogs was my final project for the Higher National Diploma in Web Application Development (*Grado Superior de Desarrollo de Aplicaciones Web*). It is no longer online, since it has been replaced by its new version, [Fort](https://fort.marcel14.dev/).

This repository is kept as a record of the project and as a way to point out, as a self-review, the mistakes I made back then.

## Background and design decisions

The assignment was a website (it could not be a mobile app) with a working frontend and backend. Unlike my classmates, I had to build this project on my own, which limited my time and hurt the final result. Even so, several classmates helped me by teaching me things I didn't know — I thanked them back then and I'm still grateful.

At the time I had no idea about React or APIs; this was my first contact with both. Today I have almost two years of professional experience with React at Apex World, where I build a gamified CRM for NGO fundraising.

The code is being annotated (work in progress) with comments explaining the mistakes I made and what I would do differently now. I'm not rewriting the project: I only fix what blocks running or reviewing it, plus a few trivial lint-level cleanups. Now that Fort exists, a full rewrite doesn't seem necessary.

## Mistakes visible at first glance

- **Commit history:** the commits in both the original backend and frontend repositories are TERRIBLE.
- **No real authentication:** there is no JWT or session token, so bypassing security was trivial (see [Code review findings](#code-review-findings)).
- **Poor use of React hooks.**
- **No ORM or migrations:** the database tables are created from a raw SQL file. An ORM such as Drizzle or Prisma would provide a typed schema and versioned migrations.
- **No TypeScript and no validation:** there are no types for the data sent to or received from the API, and nothing validates it at runtime. TypeScript plus a schema validator like Zod would ensure the data has the expected shape and types.
- **`.env` committed:** the frontend's `.env` file was committed to the repository.
- **No Tailwind:** styling is spread across too many CSS files.
- **Lowercase component names:** many JSX files `export default` a component function whose name starts with a lowercase letter: `logIn`, `editSession`, `editUser`, `editPlanedRoutine`, `privacyPolitics` and `userPremium`. `editFreeRoutine.jsx` even exports a function called `editPlanedRoutine` (copy-paste). React component names must start with an uppercase letter because:
  - **JSX uses the first letter to decide what to render:** `<EditUser />` is compiled to `React.createElement(EditUser)`, a reference to your component, while `<editUser />` is compiled to `React.createElement("edituser")`, an HTML tag that doesn't exist. Using a lowercase component in JSX silently renders an empty, unknown element.
  - **The Rules of Hooks rely on it:** the `react-hooks/rules-of-hooks` lint only allows hooks inside functions that look like components (PascalCase) or custom hooks (`use...`), so every `useState`/`useEffect` in these files is reported as an error.
  - **Readability and tooling:** PascalCase is the convention that tells a component apart from a regular function, and it's the name shown in React DevTools and in error stack traces.

  It only worked by accident: a default export can be imported under any name, and `App.jsx` imports them as `EditUser`, `EditSession`, etc. All of them have been renamed to PascalCase during the review.
- **Almost no componentization:** the whole frontend has only two reusable components (`navComponent` and `gitCalendar`); everything else lives inside 16 page files totalling about 6,600 lines. Several pages are huge (`editSession.jsx` and `devTools.jsx` have over 1,000 lines each, `home.jsx` over 900), and the same pieces are copy-pasted between them: popups, form warnings, close buttons, week-day selectors, routine cards… They should be split into small reusable components (`Modal`, `FormWarning`, `WeekDaySelector`, `RoutineCard`…), which would make the code easier to read, test and maintain.
- **Unused imports and variables:** many files import things they never use, usually the default `React` import (not needed with the new JSX transform) or hooks like `useRef` and `useEffect`. In the original code, 10 frontend files had unused imports, and `npm run lint` also reports several unused variables (see [Code review findings](#code-review-findings)).
- **Login when the backend is down:** the login page redirects to the app whenever a `token` cookie exists, without validating it against the backend. Since that cookie is just the user ID and never expires, having logged in once (or creating the cookie by hand) is enough to get in, even with the backend down.

## Code review findings

### Security

- **Trivial admin access:** after logging in, the frontend stores the user's ID in a `token` cookie and their role (a number sent by the backend) in a `userRole` cookie. The UI decides what to show based on that cookie, so editing it in the browser gives you access to the admin panel, and the backend accepts any request that includes a user ID. The fix would be JWT-based authentication with the role inside the signed token, checked by the backend on every request, plus a `useAuth` hook in the frontend that reads the role from it.
- **Anyone can register as admin:** the `register` function in `frontend/src/services/userApi.js` sends `urole: 2` from the client, and the backend stores whatever role it receives. Sending the same request with `urole: 1` creates an admin account. The role should always be assigned by the backend.
- **Unprotected endpoints:** no request sends a token or credentials. Endpoints such as `PUT /users/urole/:id` (change a user's role), deleting users or changing emails only need an ID in the URL.
- **Seed users in the SQL file:** `backend/sql/databse.sql` inserts the initial users (including the admin) directly. The only protection is that the passwords are hashed. The admin credentials should come from environment variables (e.g. `ADMIN_USER` / `ADMIN_PASSWORD` in `.env`), and a function should create the admin user the first time the project starts.
- **Password handling:**
  - The login endpoint returns the plain-text password in its response.
  - The frontend logs the email and password to the browser console on login.
  - Changing the password sends the current password in the URL (`PUT /users/password/:id/:currentPassword`), so it ends up in logs and in the browser history.
  - The backend logged the current password and the hashes when changing it.

### Code quality

- **API client ignores HTTP status codes:** the fetch helpers in `frontend/src/services/userApi.js` never checked `response.ok`, so a 409, 404 or 500 looked like a success. The UI can't tell, for example, "email already registered" (409) from a server error, and shows the same generic message for everything.
- **Confusing or inconsistent names in `frontend/src/services/userApi.js`:** for example, `getSessionsByRoutineId(session_id)` actually receives a routine ID, `getMainRoutineByUserAndRoutine(routine_id, user_id)` takes its arguments in the opposite order to its name, and there's a typo in `deleteFecth`.
- **Unused imports** (reported by `npm run lint`):
  - `React` in `App.jsx`, `login.jsx`, `register.jsx`, `routine.jsx`, `gitCalendar.jsx`, `devTools.jsx`, `editFreeRoutine.jsx`, `editPlanedRoutine.jsx` and `editSession.jsx`.
  - Hooks: `useRef` in `login.jsx`, `register.jsx` and `calendar.jsx`; `useEffect` in `register.jsx`.
  - Others: `useParams` in `App.jsx` and `getCalendarBySessionExerciseAndDate` in `home.jsx`.
  - All of them have been removed during the review.
- **Unused variables:** `getBack` (`editPlanedRoutine.jsx`), `indexofExercise` (`editSession.jsx`), `closeSession` (`privacyPolitics.jsx`), `tokenAccess` (`userPremium.jsx`), `dayIndex` (`gitCalendar.jsx`) and `data` (`home.jsx`), among others.
- **Leftover `console.log` calls** across the frontend and backend.
- **Login page (`frontend/src/pages/login.jsx`):**
  - An invalid email showed no message: the code hid the password warning instead of showing the email one, and the warnings were never reset.
  - Network errors weren't handled: with the backend down, the request failed with an uncaught promise rejection and the user saw nothing.
  - The component was named `logIn` instead of `Login`. React components must be PascalCase, and the lowercase name made the `rules-of-hooks` lint flag every hook.
  - Smaller issues: duplicated conditions (`x || x`), a useless `works` variable, `navigate` missing from the `useEffect` dependencies, hand-made validation with one state per message, and a `<button>` inside an `<a>` instead of a React Router `<Link>`.
- **Routines page (`frontend/src/pages/routine.jsx`):**
  - **Typo in the free routine validation:** `inputValue.lenth < 3` is always false (`undefined < 3`), so the minimum length check never triggers and names with 1–2 characters are accepted.
  - **Works by pure luck:** the routine list is stored without checking for errors. With no routines the backend returns `404 { error: "Not found" }`, and the "create a routine" message only shows because an object has no `length`. The frontend should check `Array.isArray(data)`, and the backend should return `200 []` when the list is empty.
  - **State mutation:** `selectedDays.sort(...)` sorts the React state array in place instead of sorting a copy.
  - **Planned routines created in several requests:** the routine first, then one session per day. If one fails, the data is left inconsistent, and since `postAndPutFetch` doesn't reject on HTTP errors, `Promise.all` treats failed sessions as successful and navigates anyway. A single backend endpoint should create everything in a transaction.
  - **Weak checks:** `routineID !== null` doesn't catch `undefined` (it would navigate to `/editPlanedRoutine/undefined`), and if the response is `null`, `data.error` throws a `TypeError`.
  - **Errors detected by message text:** the 5-routine limit is detected by comparing the string `"No se pueden tener más de 5 rutinas"` instead of the HTTP status (the backend already returns 403).
  - **No reusable auth hook:** the "must be logged in" check is copied into the page and only checks that the cookie exists, without validating it against the backend. It should be a `useAuth` hook.
  - **No data caching:** every visit refetches everything. A library like TanStack Query or SWR would cache the data and handle loading and error states.
  - **Barely split into components:** the popups, the week-day selector (7 copy-pasted buttons) and the routine list could be separate components.
  - Smaller issues: validation warnings that are never fully reset, duplicated conditions (`x || x`), `key={index}` instead of `routine.pk_id_routine`, an unused default `React` import, and leftover commented-out HTML.

## What I've added or changed in this repository

- Merged the two original repositories (frontend and backend) into a single one, with the folders renamed to `frontend/` and `backend/`.
- A `justfile` to run everything with a single command.
- A `docker-compose.yml` in the backend that runs the MySQL database it needs, initialised from `backend/sql/databse.sql`. It was needed to start reviewing the project.
- A `.env.example` in the backend.
- Fixed `getFetch` in `frontend/src/services/userApi.js`: it crashed when the response wasn't JSON, which blocked the review. It now checks `response.ok` and returns an error object (`{ error, status }`) when the request fails.
- Fixed the bugs that kept the login page (`frontend/src/pages/login.jsx`) from working:
  - An invalid email now shows its warning, and the warnings are reset on every submit.
  - Network errors are caught and show a "can't connect to the server" popup.
  - The component was renamed from `logIn` to `Login`.
  - The duplicated `x || x` conditions were removed.
- Renamed every lowercase component to PascalCase (`logIn`, `editSession`, `editUser`, `editPlanedRoutine`, `privacyPolitics`, `userPremium`, and the free routine page's `editPlanedRoutine`, now `EditFreeRoutine`).
- Removed every unused import reported by the linter, leaving the original line commented out next to an explanation.
- Small changes in the routines page (`frontend/src/pages/routine.jsx`): removed the unused default `React` import, and `editRoutine` now logs errors instead of ignoring them (it had an empty `else` and an empty `.catch`).
- Commented out the example routines and sessions in the SQL seed file.
- Review comments in the code pointing out the mistakes (work in progress).

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
