"use client";

import { useRouter } from "next/navigation";

import { ROUTES } from "@/constants/routes";
import { useAuth } from "@/context/AuthContext";

export default function Topbar() {
  const router = useRouter();

  const { logout, user } = useAuth();

  async function handleLogout() {
    await logout();
    router.push(ROUTES.LOGIN);
  }

  return (
    <header className="h-16 bg-white border-b px-8 flex items-center justify-between">
      <div>
        <h2 className="font-semibold text-slate-900">
          ValetWatch Dashboard
        </h2>

        <p className="text-sm text-slate-500">
          Smart valet monitoring platform
        </p>
      </div>

      <div className="flex items-center gap-4">
        <div className="text-right">
          <p className="font-medium text-slate-900">
            {user?.name}
          </p>

          <p className="text-xs text-slate-500">
            {user?.email}
          </p>
        </div>

        <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700 capitalize">
          {user?.role?.replaceAll("_", " ")}
        </span>

        <button
          onClick={handleLogout}
          className="bg-slate-900 text-white px-4 py-2 rounded-lg text-sm"
        >
          Logout
        </button>
      </div>
    </header>
  );
}