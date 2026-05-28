type Props = {
  title: string;
  value: string | number;
  description: string;
};

export default function StatCard({
  title,
  value,
  description,
}: Props) {
  return (
    <div className="bg-white rounded-2xl shadow-sm p-6 border">
      <p className="text-sm text-slate-500 mb-2">
        {title}
      </p>

      <h2 className="text-3xl font-bold text-slate-900">
        {value}
      </h2>

      <p className="text-sm text-slate-400 mt-2">
        {description}
      </p>
    </div>
  );
}