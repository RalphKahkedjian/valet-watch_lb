class VehicleModel {
  final int id;
  final String brand;
  final String model;
  final String plateNumber;
  final String color;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.color,
  });

  factory VehicleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VehicleModel(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      plateNumber: json['plate_number'],
      color: json['color'],
    );
  }
}