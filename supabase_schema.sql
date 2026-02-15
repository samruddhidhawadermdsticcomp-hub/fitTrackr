-- Supabase / Postgres schema for the fitness-tracker project
-- Run this in your Supabase SQL Editor (or psql) to create required tables.

-- Ensure the `pgcrypto` extension (for gen_random_uuid)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Helper: automatic updated_at updater
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Exercises table
CREATE TABLE IF NOT EXISTS public.exercises (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category text NOT NULL,
  description text,
  target_muscle_groups text[],
  is_preset boolean NOT NULL DEFAULT false,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT preset_exercises_have_null_user_id CHECK (NOT (is_preset = TRUE AND user_id IS NOT NULL)),
  CONSTRAINT custom_exercises_have_user_id CHECK (NOT (is_preset = FALSE AND user_id IS NULL))
);

CREATE UNIQUE INDEX IF NOT EXISTS unique_preset_name_idx ON public.exercises (name) WHERE user_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS unique_user_custom_exercise_name_idx ON public.exercises (user_id, name) WHERE user_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_exercises_user_id ON public.exercises(user_id);
CREATE INDEX IF NOT EXISTS idx_exercises_is_preset ON public.exercises(is_preset);
CREATE INDEX IF NOT EXISTS idx_exercises_category ON public.exercises(category);

CREATE TRIGGER update_exercises_updated_at
BEFORE UPDATE ON public.exercises
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Workouts table
CREATE TABLE IF NOT EXISTS public.workouts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date date NOT NULL,
  exercise text NOT NULL,
  sets integer NOT NULL,
  reps integer NOT NULL,
  weight numeric NOT NULL,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON public.workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_date ON public.workouts(date);

CREATE TRIGGER update_workouts_updated_at
BEFORE UPDATE ON public.workouts
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Metrics table
CREATE TABLE IF NOT EXISTS public.metrics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date date NOT NULL,
  weight numeric,
  body_fat numeric,
  photo_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_metrics_user_id ON public.metrics(user_id);
CREATE INDEX IF NOT EXISTS idx_metrics_date ON public.metrics(date);

CREATE TRIGGER update_metrics_updated_at
BEFORE UPDATE ON public.metrics
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Workout templates
CREATE TABLE IF NOT EXISTS public.workout_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  exercises jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_templates_user_id ON public.workout_templates(user_id);

CREATE TRIGGER update_templates_updated_at
BEFORE UPDATE ON public.workout_templates
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Optional: seed a few preset exercises (only run once)
-- INSERT INTO public.exercises (name, category, description, target_muscle_groups, is_preset, user_id)
-- VALUES ('Bench Press', 'Chest', 'Compound movement', '{"Pectorals","Deltoids","Triceps"}', TRUE, NULL);

-- End of schema
