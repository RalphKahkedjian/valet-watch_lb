export type User = {
  id: number;
  name: string;
  email: string;
  phone?: string;
  role: "customer" | "valet_attendant" | "valet_company" | "government_admin" | "admin";
};

export type LoginPayload = {
  email: string;
  password: string;
};

export type LoginResponse = {
  message: string;
  user: User;
  token: string;
};