import api from "./api";

export const reportService = {
  async getReports() {
    const response = await api.get("/parking-zone-reports");
    return response.data.data;
  },

  async updateStatus(
    reportId: number,
    status: string
  ) {
    const response = await api.patch(
      `/parking-zone-reports/${reportId}/status`,
      {
        status,
      }
    );

    return response.data.data;
  },
};