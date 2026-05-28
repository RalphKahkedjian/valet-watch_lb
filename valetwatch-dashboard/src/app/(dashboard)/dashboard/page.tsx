"use client";

import { useEffect, useState } from "react";
import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

import ChartCard from "@/components/dashboard/ChartCard";
import StatCard from "@/components/dashboard/StatCard";
import { analyticsService } from "@/services/analyticsService";
import { dashboardService } from "@/services/dashboardService";

type Stats = {
  total_reports: number;
  active_sessions: number;
  parking_zones: number;
  overcharge_cases: number;
};

type ChartItem = {
  name: string;
  value: number;
};

type Charts = {
  reports_by_type: ChartItem[];
  sessions_by_status: ChartItem[];
};

const pieColors = ["#ef4444", "#f97316", "#eab308", "#3b82f6", "#64748b"];

export default function DashboardPage() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [charts, setCharts] = useState<Charts | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        const [statsData, chartsData] = await Promise.all([
          dashboardService.getStats(),
          analyticsService.getDashboardCharts(),
        ]);

        setStats(statsData);
        setCharts(chartsData);
      } catch (error) {
        console.error(error);
      }
    }

    fetchData();
  }, []);

  if (!stats || !charts) {
    return <div className="text-slate-500">Loading dashboard...</div>;
  }

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">
          Dashboard Overview
        </h1>

        <p className="text-slate-500 mt-2">
          Monitor valet parking activity, reports, and risk patterns.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
        <StatCard
          title="Total Reports"
          value={stats.total_reports}
          description="Fake valet reports submitted"
        />

        <StatCard
          title="Active Sessions"
          value={stats.active_sessions}
          description="Vehicles currently parked"
        />

        <StatCard
          title="Parking Zones"
          value={stats.parking_zones}
          description="Registered valet zones"
        />

        <StatCard
          title="Overcharge Cases"
          value={stats.overcharge_cases}
          description="Reported pricing violations"
        />
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6 mt-8">
        <ChartCard title="Reports by Type">
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={charts.reports_by_type}
                dataKey="value"
                nameKey="name"
                outerRadius={110}
                label
              >
                {charts.reports_by_type.map((_, index) => (
                  <Cell
                    key={index}
                    fill={pieColors[index % pieColors.length]}
                  />
                ))}
              </Pie>

              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Parking Sessions by Status">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={charts.sessions_by_status}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis allowDecimals={false} />
              <Tooltip />
              <Bar dataKey="value" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>
    </div>
  );
}