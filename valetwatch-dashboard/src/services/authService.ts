import api from "./api";
import { LoginPayload, LoginResponse } from "@/types/auth";

export const authService = {
  async login(payload: LoginPayload): Promise<LoginResponse> {
    const response = await api.post<LoginResponse>("/login", payload);
    return response.data;
  },

  async me() {
    const response = await api.get("/me");
    return response.data;
  },

  async logout() {
    const response = await api.post("/logout");
    return response.data;
  },
};