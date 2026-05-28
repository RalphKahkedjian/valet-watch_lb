"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { useAuth } from "@/context/AuthContext";

type LinkItem = {
  label: string;
  href: string;
  roles: string[];
};

const links: LinkItem[] = [
  {
    label: "Dashboard",
    href: "/dashboard",
    roles: ["admin", "government_admin", "valet_company"],
  },

  {
    label: "Reports",
    href: "/reports",
    roles: ["admin", "government_admin"],
  },

  {
    label: "Parking Zones",
    href: "/parking-zones",
    roles: ["admin", "government_admin"],
  },

  {
    label: "Map",
    href: "/map",
    roles: ["admin", "government_admin"],
  },

  {
    label: "Parking Sessions",
    href: "/parking-sessions",
    roles: ["admin", "valet_company"],
  },
];

export default function Sidebar() {
  const pathname = usePathname();

  const { user } = useAuth();

  const filteredLinks = links.filter((link) =>
    link.roles.includes(user?.role ?? "")
  );

  return (
    <aside className="w-64 bg-slate-900 text-white min-h-screen p-6">
      <h1 className="text-2xl font-bold mb-2">
        ValetWatch
      </h1>

      <p className="text-slate-400 text-sm mb-10">
        Smart Valet Monitoring
      </p>

      <nav className="space-y-2">
        {filteredLinks.map((link) => {
          const active = pathname === link.href;

          return (
            <Link
              key={link.href}
              href={link.href}
              className={`block rounded-lg px-4 py-3 transition ${
                active
                  ? "bg-slate-700"
                  : "hover:bg-slate-800"
              }`}
            >
              {link.label}
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}