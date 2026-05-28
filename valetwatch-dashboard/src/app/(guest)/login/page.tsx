"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { ROUTES } from "@/constants/routes";
import { useAuth } from "@/context/AuthContext";

export default function LoginForm() {
  const router = useRouter();
  const { login } = useAuth();

  const [email, setEmail] = useState("ralph@test.com");
  const [password, setPassword] = useState("password123");

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    try {
      setLoading(true);
      setError("");

      await login({
        email,
        password,
      });

      router.push(ROUTES.DASHBOARD);

    } catch {
      setError("Invalid email or password");
    } finally {
      setLoading(false);
    }
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="w-full max-w-md bg-white rounded-2xl shadow p-8"
    >
      <h1 className="text-3xl font-bold text-slate-900">
        ValetWatch
      </h1>

      <p className="text-slate-500 mt-2 mb-6">
        Login to dashboard
      </p>

      {error && (
        <div className="mb-4 bg-red-100 text-red-700 rounded-lg p-3 text-sm">
          {error}
        </div>
      )}

      <div className="mb-4">
        <label className="block mb-1 text-sm font-medium">
          Email
        </label>

        <input
          type="email"
          className="w-full border rounded-lg px-3 py-2"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </div>

      <div className="mb-6">
        <label className="block mb-1 text-sm font-medium">
          Password
        </label>

        <input
          type="password"
          className="w-full border rounded-lg px-3 py-2"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
      </div>

      <button
        disabled={loading}
        className="w-full bg-slate-900 text-white rounded-lg py-2 font-medium"
      >
        {loading ? "Loading..." : "Login"}
      </button>
    </form>
  );
}