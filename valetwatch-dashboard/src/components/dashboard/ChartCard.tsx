type Props = {
  title: string;
  children: React.ReactNode;
};

export default function ChartCard({ title, children }: Props) {
  return (
    <div className="bg-white rounded-2xl border shadow-sm p-6">
      <h2 className="text-lg font-semibold text-slate-900 mb-6">
        {title}
      </h2>

      <div className="h-80">
        {children}
      </div>
    </div>
  );
}