import api from "./api";

export const analyticsService = {
  async getDashboardCharts() {
    const response = await api.get("/analytics/dashboard-charts");
    return response.data.data;
  },
};