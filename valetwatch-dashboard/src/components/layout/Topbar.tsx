"use client";

import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";
import { ROUTES } from "@/constants/routes";

export default function Topbar() {
  const router = useRouter();
  const { logout } = useAuth();

  async function handleLogout() {
    await logout();
    router.push(ROUTES.LOGIN);
  }

  return (
    <header className="h-16 bg-white border-b px-8 flex items-center justify-between">
      <div>
        <h2 className="font-semibold text-slate-900">Admin Dashboard</h2>
        <p className="text-sm text-slate-500">Monitor valet activity</p>
      </div>

      <button
        onClick={handleLogout}
        className="bg-slate-900 text-white px-4 py-2 rounded-lg text-sm"
      >
        Logout
      </button>
    </header>
  );
}