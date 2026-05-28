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
  async exportCsv() {
  const response = await api.get("/parking-zone-reports/export/csv", {
    responseType: "blob",
  });

  const url = window.URL.createObjectURL(new Blob([response.data]));
  const link = document.createElement("a");

  link.href = url;
  link.setAttribute("download", "parking-zone-reports.csv");

  document.body.appendChild(link);
  link.click();
  link.remove();

  window.URL.revokeObjectURL(url);
}
};