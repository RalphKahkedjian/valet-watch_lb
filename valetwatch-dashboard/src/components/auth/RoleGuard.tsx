"use client";

import { useAuth } from "@/context/AuthContext";

type Props = {
  allowedRoles: string[];
  children: React.ReactNode;
};

export default function RoleGuard({
  allowedRoles,
  children,
}: Props) {
  const { user } = useAuth();

  if (!user) {
    return null;
  }

  if (!allowedRoles.includes(user.role)) {
    return (
      <div className="rounded-2xl border bg-white p-8">
        <h1 className="text-2xl font-bold text-slate-900">
          Access Denied
        </h1>

        <p className="text-slate-500 mt-2">
          You do not have permission to view this page.
        </p>
      </div>
    );
  }

  return <>{children}</>;
}