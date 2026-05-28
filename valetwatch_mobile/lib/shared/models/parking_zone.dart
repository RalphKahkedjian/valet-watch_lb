class ParkingZone {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;
  final String officialPrice;
  final String status;
  final bool isPublic;

  ParkingZone({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.officialPrice,
    required this.status,
    required this.isPublic,
  });

  factory ParkingZone.fromJson(Map<String, dynamic> json) {
    return ParkingZone(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      radius: json['radius'],
      officialPrice: json['official_price'].toString(),
      status: json['status'],
      isPublic: json['is_public'] == true || json['is_public'] == 1,
    );
  }
}