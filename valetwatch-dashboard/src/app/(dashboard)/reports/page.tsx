"use client";

import { useEffect, useMemo, useState } from "react";

import RoleGuard from "@/components/auth/RoleGuard";
import StatusBadge from "@/components/ui/StatusBadge";
import { reportService } from "@/services/reportService";

type Report = {
  id: number;
  report_type: string;
  description: string | null;
  image_path?: string | null;
  status: string;
  created_at: string;

  user?: {
    name: string;
    email: string;
  };

  zone?: {
    name: string;
  };
};

export default function ReportsPage() {
  const [reports, setReports] = useState<Report[]>([]);

  const [search, setSearch] = useState("");

  const [statusFilter, setStatusFilter] =
    useState("");

  const [typeFilter, setTypeFilter] =
    useState("");

  async function fetchReports() {
    try {
      const data = await reportService.getReports();
      setReports(data);
    } catch (error) {
      console.error(error);
    }
  }

  async function handleStatusUpdate(
    reportId: number,
    status: string
  ) {
    try {
      await reportService.updateStatus(
        reportId,
        status
      );

      await fetchReports();
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    fetchReports();
  }, []);

  const filteredReports = useMemo(() => {
    return reports.filter((report) => {
      const matchesSearch =
        report.description
          ?.toLowerCase()
          .includes(search.toLowerCase()) ||
        report.user?.name
          ?.toLowerCase()
          .includes(search.toLowerCase()) ||
        report.zone?.name
          ?.toLowerCase()
          .includes(search.toLowerCase());

      const matchesStatus =
        !statusFilter ||
        report.status === statusFilter;

      const matchesType =
        !typeFilter ||
        report.report_type === typeFilter;

      return (
        matchesSearch &&
        matchesStatus &&
        matchesType
      );
    });
  }, [reports, search, statusFilter, typeFilter]);

  return (
    <RoleGuard
      allowedRoles={[
        "admin",
        "government_admin",
      ]}
    >
      <div>
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-slate-900">
              Reports Management
            </h1>

            <p className="text-slate-500 mt-2">
              Review fake valet,
              overcharging, and unsafe area
              reports.
            </p>
          </div>

          <button
            onClick={() =>
              reportService.exportCsv()
            }
            className="bg-slate-900 text-white px-4 py-2 rounded-lg text-sm font-medium"
          >
            Export CSV
          </button>
        </div>

        <div className="bg-white rounded-2xl border shadow-sm p-4 mb-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input
              type="text"
              placeholder="Search reports..."
              value={search}
              onChange={(e) =>
                setSearch(e.target.value)
              }
              className="border rounded-lg px-4 py-2"
            />

            <select
              value={statusFilter}
              onChange={(e) =>
                setStatusFilter(e.target.value)
              }
              className="border rounded-lg px-4 py-2"
            >
              <option value="">
                All Statuses
              </option>

              <option value="open">
                Open
              </option>

              <option value="reviewing">
                Reviewing
              </option>

              <option value="resolved">
                Resolved
              </option>

              <option value="rejected">
                Rejected
              </option>
            </select>

            <select
              value={typeFilter}
              onChange={(e) =>
                setTypeFilter(e.target.value)
              }
              className="border rounded-lg px-4 py-2"
            >
              <option value="">
                All Types
              </option>

              <option value="fake_valet">
                Fake Valet
              </option>

              <option value="overcharging">
                Overcharging
              </option>

              <option value="unsafe_area">
                Unsafe Area
              </option>

              <option value="public_spot_claimed">
                Public Spot Claimed
              </option>
            </select>
          </div>
        </div>

        <div className="bg-white rounded-2xl border shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-100 text-slate-600">
              <tr>
                <th className="text-left p-4">
                  Type
                </th>

                <th className="text-left p-4">
                  Zone
                </th>

                <th className="text-left p-4">
                  User
                </th>

                <th className="text-left p-4">
                  Description
                </th>

                <th className="text-left p-4">
                  Evidence
                </th>

                <th className="text-left p-4">
                  Status
                </th>

                <th className="text-left p-4">
                  Actions
                </th>
              </tr>
            </thead>

            <tbody>
              {filteredReports.map((report) => (
                <tr
                  key={report.id}
                  className="border-t hover:bg-slate-50 transition"
                >
                  <td className="p-4">
                    <StatusBadge
                      status={
                        report.report_type
                      }
                    />
                  </td>

                  <td className="p-4 font-medium text-slate-700">
                    {report.zone?.name ??
                      "No zone"}
                  </td>

                  <td className="p-4">
                    <p className="font-medium text-slate-800">
                      {report.user?.name ??
                        "Unknown"}
                    </p>

                    <p className="text-xs text-slate-500">
                      {report.user?.email ??
                        "-"}
                    </p>
                  </td>

                  <td className="p-4 text-slate-500 max-w-md">
                    {report.description ??
                      "No description"}
                  </td>

                  <td className="p-4">
                    {report.image_path ? (
                      <img
                        src={`http://127.0.0.1:8000/storage/${report.image_path}`}
                        alt="Evidence"
                        className="w-20 h-20 rounded-lg object-cover border"
                      />
                    ) : (
                      <span className="text-slate-400 text-xs">
                        No image
                      </span>
                    )}
                  </td>

                  <td className="p-4">
                    <StatusBadge
                      status={report.status}
                    />
                  </td>

                  <td className="p-4">
                    <div className="flex gap-2">
                      <button
                        onClick={() =>
                          handleStatusUpdate(
                            report.id,
                            "reviewing"
                          )
                        }
                        className="rounded-lg bg-blue-100 px-3 py-1 text-xs font-medium text-blue-700"
                      >
                        Review
                      </button>

                      <button
                        onClick={() =>
                          handleStatusUpdate(
                            report.id,
                            "resolved"
                          )
                        }
                        className="rounded-lg bg-green-100 px-3 py-1 text-xs font-medium text-green-700"
                      >
                        Resolve
                      </button>

                      <button
                        onClick={() =>
                          handleStatusUpdate(
                            report.id,
                            "rejected"
                          )
                        }
                        className="rounded-lg bg-red-100 px-3 py-1 text-xs font-medium text-red-700"
                      >
                        Reject
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {filteredReports.length === 0 && (
            <div className="p-6 text-slate-500">
              No matching reports found.
            </div>
          )}
        </div>
      </div>
    </RoleGuard>
  );
}