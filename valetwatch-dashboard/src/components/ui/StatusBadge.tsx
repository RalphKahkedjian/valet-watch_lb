type Props = {
  status: string;
};

export default function StatusBadge({ status }: Props) {
  const styles: Record<string, string> = {
    open: "bg-yellow-100 text-yellow-700",
    reviewing: "bg-blue-100 text-blue-700",
    resolved: "bg-green-100 text-green-700",
    rejected: "bg-red-100 text-red-700",

    fake_valet: "bg-red-100 text-red-700",
    overcharging: "bg-orange-100 text-orange-700",
    public_spot_claimed: "bg-purple-100 text-purple-700",
    unsafe_area: "bg-yellow-100 text-yellow-700",
    other: "bg-slate-100 text-slate-700",
  };

  return (
    <span
      className={`px-3 py-1 rounded-full text-xs font-medium ${
        styles[status] ?? "bg-slate-100 text-slate-700"
      }`}
    >
      {status.replaceAll("_", " ")}
    </span>
  );
}