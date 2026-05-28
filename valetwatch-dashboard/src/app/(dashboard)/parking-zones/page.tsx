"use client";

import { useEffect, useState } from "react";

import StatusBadge from "@/components/ui/StatusBadge";
import { parkingZoneService } from "@/services/parkingZoneService";

type ParkingZone = {
  id: number;
  name: string;
  latitude: string | number;
  longitude: string | number;
  radius: number;
  official_price: string | number;
  status: string;
  is_public: boolean;
};

export default function ParkingZonesPage() {
  const [zones, setZones] = useState<ParkingZone[]>([]);

  async function fetchZones() {
    try {
      const data = await parkingZoneService.getZones();
      setZones(data);
    } catch (error) {
      console.error(error);
    }
  }

  async function handleStatusUpdate(
    zoneId: number,
    status: string
  ) {
    try {
      await parkingZoneService.updateStatus(zoneId, status);
      await fetchZones();
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    fetchZones();
  }, []);

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">
          Parking Zones
        </h1>

        <p className="text-slate-500 mt-2">
          Manage valet parking zones and approvals.
        </p>
      </div>

      <div className="bg-white rounded-2xl border shadow-sm overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-slate-100 text-slate-600">
            <tr>
              <th className="text-left p-4">Zone</th>
              <th className="text-left p-4">Coordinates</th>
              <th className="text-left p-4">Radius</th>
              <th className="text-left p-4">Official Price</th>
              <th className="text-left p-4">Public</th>
              <th className="text-left p-4">Status</th>
              <th className="text-left p-4">Actions</th>
            </tr>
          </thead>

          <tbody>
            {zones.map((zone) => (
              <tr
                key={zone.id}
                className="border-t hover:bg-slate-50 transition"
              >
                <td className="p-4 font-medium text-slate-800">
                  {zone.name}
                </td>

                <td className="p-4 text-slate-500">
                  {zone.latitude}, {zone.longitude}
                </td>

                <td className="p-4">{zone.radius}m</td>

                <td className="p-4">{zone.official_price} L.L</td>

                <td className="p-4">
                  {zone.is_public ? (
                    <span className="text-green-600 font-medium">
                      Public
                    </span>
                  ) : (
                    <span className="text-slate-500">
                      Private
                    </span>
                  )}
                </td>

                <td className="p-4">
                  <StatusBadge status={zone.status} />
                </td>

                <td className="p-4">
                  <div className="flex gap-2">
                    <button
                      onClick={() =>
                        handleStatusUpdate(zone.id, "approved")
                      }
                      className="rounded-lg bg-green-100 px-3 py-1 text-xs font-medium text-green-700"
                    >
                      Approve
                    </button>

                    <button
                      onClick={() =>
                        handleStatusUpdate(zone.id, "rejected")
                      }
                      className="rounded-lg bg-red-100 px-3 py-1 text-xs font-medium text-red-700"
                    >
                      Reject
                    </button>

                    <button
                      onClick={() =>
                        handleStatusUpdate(zone.id, "suspended")
                      }
                      className="rounded-lg bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700"
                    >
                      Suspend
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {zones.length === 0 && (
          <div className="p-6 text-slate-500">
            No parking zones found.
          </div>
        )}
      </div>
    </div>
  );
}