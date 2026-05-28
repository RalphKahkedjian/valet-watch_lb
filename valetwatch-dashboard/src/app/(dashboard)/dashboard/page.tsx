import StatCard from "@/components/dashboard/StatCard";

export default function DashboardPage() {
  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">
          Dashboard Overview
        </h1>

        <p className="text-slate-500 mt-2">
          Monitor valet parking activity and reports.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
        <StatCard
          title="Total Reports"
          value="128"
          description="Fake valet reports submitted"
        />

        <StatCard
          title="Active Sessions"
          value="42"
          description="Vehicles currently parked"
        />

        <StatCard
          title="Parking Zones"
          value="17"
          description="Approved valet zones"
        />

        <StatCard
          title="Overcharge Cases"
          value="9"
          description="Reported pricing violations"
        />
      </div>
    </div>
  );
}