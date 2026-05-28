"use client";

import { useEffect, useState } from "react";

import L from "leaflet";

import {
  Circle,
  MapContainer,
  Marker,
  Popup,
  TileLayer,
} from "react-leaflet";

import { parkingZoneService } from "@/services/parkingZoneService";

type ParkingZone = {
  id: number;
  name: string;
  latitude: string | number;
  longitude: string | number;
  radius: number;
  official_price: string | number;
  status: string;
  is_public: boolean;
};

const greenIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

const yellowIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-yellow.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

const redIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
});

export default function MapPage() {
  const [zones, setZones] = useState<ParkingZone[]>([]);

  useEffect(() => {
    async function fetchZones() {
      try {
        const data = await parkingZoneService.getZones();
        setZones(data);
      } catch (error) {
        console.error(error);
      }
    }

    fetchZones();
  }, []);

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900">
          Valet Activity Map
        </h1>

        <p className="text-slate-500 mt-2">
          Monitor parking zones and fake valet hotspots.
        </p>
      </div>

      <div className="overflow-hidden rounded-2xl border bg-white">
        <MapContainer
          center={[33.8938, 35.5018]}
          zoom={13}
          style={{
            height: "700px",
            width: "100%",
          }}
        >
          <TileLayer
            attribution="&copy; OpenStreetMap contributors"
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />

          {zones.map((zone) => (
            <Circle
              key={`circle-${zone.id}`}
              center={[
                Number(zone.latitude),
                Number(zone.longitude),
              ]}
              radius={Number(zone.radius) * 3}
              pathOptions={{
                color:
                  zone.status === "approved"
                    ? "green"
                    : zone.status === "pending"
                    ? "orange"
                    : "red",

                fillColor:
                  zone.status === "approved"
                    ? "green"
                    : zone.status === "pending"
                    ? "orange"
                    : "red",

                fillOpacity: 0.18,
              }}
            />
          ))}

          {zones.map((zone) => (
            <Marker
              key={zone.id}
              position={[
                Number(zone.latitude),
                Number(zone.longitude),
              ]}
              icon={
                zone.status === "approved"
                  ? greenIcon
                  : zone.status === "pending"
                  ? yellowIcon
                  : redIcon
              }
            >
              <Popup>
                <div className="space-y-2">
                  <h2 className="font-bold text-base">
                    {zone.name}
                  </h2>

                  <p>
                    <span className="font-medium">
                      Status:
                    </span>{" "}
                    {zone.status}
                  </p>

                  <p>
                    <span className="font-medium">
                      Official price:
                    </span>{" "}
                    {zone.official_price} L.L
                  </p>

                  <p>
                    <span className="font-medium">
                      Radius:
                    </span>{" "}
                    {zone.radius}m
                  </p>

                  <p>
                    <span className="font-medium">
                      Public:
                    </span>{" "}
                    {zone.is_public ? "Yes" : "No"}
                  </p>
                </div>
              </Popup>
            </Marker>
          ))}
        </MapContainer>
      </div>
    </div>
  );
}