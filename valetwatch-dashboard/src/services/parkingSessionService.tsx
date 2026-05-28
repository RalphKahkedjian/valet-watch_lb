import api from "./api";

export const parkingSessionService = {
  async getSessions() {
    const response = await api.get("/parking-sessions");
    return response.data.data;
  },
};