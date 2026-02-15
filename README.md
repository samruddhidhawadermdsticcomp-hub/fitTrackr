# FitTrackr

FitTrackr is a web application designed to help users track their fitness journey. It allows authenticated users to manage their workouts, including creating new workouts, viewing existing ones, and potentially using templates. Users can also monitor their progress, view statistics, and manage their profiles through a personalized dashboard.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Environment Setup](#environment-setup)
- [Running the Project](#running-the-project)
- [Building the Project](#building-the-project)
- [Available Scripts](#available-scripts)
- [Technologies Used](#technologies-used)
- [Database Setup](#database-setup)

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Node.js (LTS version recommended)
- npm (comes with Node.js) or yarn

## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/shamar-morrison/fitness-tracker.git
    cd fittrackr
    ```
2.  Install dependencies:
    ```bash
    npm install
    ```
    (or `yarn install` if you prefer yarn and have it installed)

## Environment Setup

This project uses a local `.env.local` file for development and expects equivalent environment variables to be configured in your Vercel project settings for deployment.

Create a `.env.local` file in the project root (do not commit it). Example values (replace placeholders):

```env
# Public (safe for client-side usage)
NEXT_PUBLIC_SUPABASE_URL=https://<your-project-ref>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here

# Server-only (keep secret; set in Vercel as environment variables)
SUPABASE_URL=https://<your-project-ref>.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
SUPABASE_JWT_SECRET=your_jwt_secret_here
```

Notes:
- `NEXT_PUBLIC_SUPABASE_URL` must be the public HTTP URL for your Supabase project, e.g. `https://qlzywewadamjrticvtkm.supabase.co` — not a Postgres connection string.
- Do NOT expose secret keys (service role, DB credentials) to the browser; set them only in your hosting provider (Vercel) as **Environment Variables**.
- The repository previously contained a `.env` file template which has been removed; use `.env.local` locally and Vercel settings for production.

## Database Setup

I've added a consolidated schema file `supabase_schema.sql` in the repository root that creates all required tables (`exercises`, `workouts`, `metrics`, `workout_templates`), triggers, and indexes.

To create the schema in your Supabase project:

1. Open your Supabase project → SQL Editor.
2. Open `supabase_schema.sql` from this repo or copy the contents.
3. Paste and run the script. (This creates tables and triggers; seed inserts are commented out.)

If you only want the exercises table, you can still use `new_exercises_table.sql`.

## Running the Project

To run the project in development mode:

```bash
npm run dev
```

This will start the development server, usually on `http://localhost:3000`.

## Building the Project

To create a production build:

```bash
npm run build
```

This command compiles the application into static files for deployment.

## Available Scripts

In the `package.json` file, the following scripts are available:

- `dev`: Starts the development server.
- `build`: Builds the application for production.
- `start`: Starts the production server (after running `build`).
- `lint`: Lints the codebase using Next.js's ESLint configuration.
- `format`: Formats the code using Prettier.

You can run these scripts using `npm run <script-name>`. For example, `npm run lint`.

## Technologies Used

- Next.js
- React
- TypeScript
- Supabase
- Tailwind CSS
- Shadcn/ui (based on common Next.js project structures and dependencies like `@radix-ui/*`)
- ESLint
- Prettier

---

## Troubleshooting npm install

- If `npm install` fails with permission errors on Windows while the project is inside OneDrive, pause OneDrive sync or move the project outside OneDrive (e.g., `C:\projects\fitness-tracker`).
- If you see `ECONNRESET` or network errors, try:

```powershell
npm cache clean --force
npm cache verify
npm config set registry https://registry.npmjs.org/
npm config delete proxy
npm config delete https-proxy
npm config set fetch-timeout 600000
npm config set fetch-retries 5
npm install --legacy-peer-deps
```

## Deployment (Vercel)

- In Vercel set these environment variables for the appropriate environment (Preview/Production):
    - `NEXT_PUBLIC_SUPABASE_URL` (public URL)
    - `NEXT_PUBLIC_SUPABASE_ANON_KEY` (anon public key)
    - `SUPABASE_SERVICE_ROLE_KEY` (server-only)
    - `SUPABASE_JWT_SECRET` (server-only)

---

This README provides a concise guide to get the `fittrackr` project up and running.
