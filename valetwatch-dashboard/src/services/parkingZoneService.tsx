import api from "./api";

export const parkingZoneService = {
  async getZones() {
    const response = await api.get("/parking-zones");
    return response.data.data;
  },

  async updateStatus(zoneId: number, status: string) {
    const response = await api.patch(`/parking-zones/${zoneId}/status`, {
      status,
    });

    return response.data.data;
  },
};