import GuestGuard from "@/components/auth/GuestGuard";

export default function GuestLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <GuestGuard>{children}</GuestGuard>;
}