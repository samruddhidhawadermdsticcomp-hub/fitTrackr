'use client';

import { Button } from '@/components/ui/button';
import { useAuth } from '@/contexts/AuthContext';
import Link from 'next/link';

export default function Home() {
  const { user, loading } = useAuth();

  return (
    <div className="flex min-h-screen flex-col">
      <main className="flex-1">
        <section className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl lg:text-6xl">
                  Track Your Fitness Journey
                </h1>
                <p className="mx-auto max-w-[700px] text-gray-500 md:text-xl">
                  Log workouts, track progress, and achieve your fitness goals with FitTrackr.
                </p>
              </div>
              <div className="space-x-4">
                {!loading && !user && (
                  <>
                    <Button asChild size="lg">
                      <Link href="/auth/signup">Get Started Free</Link>
                    </Button>
                    <Button asChild variant="outline" size="lg">
                      <Link href="/auth/login">Login</Link>
                    </Button>
                  </>
                )}
                {!loading && user && (
                  <Button asChild size="lg">
                    <Link href="/dashboard">Go to Dashboard</Link>
                  </Button>
                )}
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
