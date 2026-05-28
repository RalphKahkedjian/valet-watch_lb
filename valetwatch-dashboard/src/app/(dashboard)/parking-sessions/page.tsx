"use client";

import { useEffect, useState } from "react";

import StatusBadge from "@/components/ui/StatusBadge";
import { parkingSessionService } from "@/services/parkingSessionService";

type ParkingSession = {
  id: number;
  start_time: string | null;
  end_time: string | null;
  official_price: string | number;
  paid_price: string | number | null;
  status: string;
  vehicle?: {
    plate_number: string;
    brand?: string;
    model?: string;
  };
  zone?: {
    name: string;
  };
};

export default function ParkingSessionsPage() {
  const [sessions, setSessions] = useState<ParkingSession[]>([]);

  useEffect(() => {
    async function fetchSessions() {
      const data = await parkingSessionService.getSessions();
      setSessions(data);
    }

    fetchSessions();
  }, []);

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">
          Parking Sessions
        </h1>
        <p className="text-slate-500 mt-2">
          Monitor active and completed valet parking sessions.
        </p>
      </div>

      <div className="bg-white rounded-2xl border shadow-sm overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-slate-100 text-slate-600">
            <tr>
              <th className="text-left p-4">Vehicle</th>
              <th className="text-left p-4">Zone</th>
              <th className="text-left p-4">Start</th>
              <th className="text-left p-4">End</th>
              <th className="text-left p-4">Official Price</th>
              <th className="text-left p-4">Paid Price</th>
              <th className="text-left p-4">Status</th>
            </tr>
          </thead>

          <tbody>
            {sessions.map((session) => (
              <tr key={session.id} className="border-t hover:bg-slate-50">
                <td className="p-4 font-medium">
                  {session.vehicle?.plate_number ?? "Unknown"}
                  <p className="text-xs text-slate-500">
                    {session.vehicle?.brand} {session.vehicle?.model}
                  </p>
                </td>
                <td className="p-4">{session.zone?.name ?? "No zone"}</td>
                <td className="p-4">{session.start_time ?? "-"}</td>
                <td className="p-4">{session.end_time ?? "-"}</td>
                <td className="p-4">{session.official_price} L.L</td>
                <td className="p-4">{session.paid_price ?? "-"} L.L</td>
                <td className="p-4">
                  <StatusBadge status={session.status} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {sessions.length === 0 && (
          <div className="p-6 text-slate-500">
            No parking sessions found.
          </div>
        )}
      </div>
    </div>
  );
}