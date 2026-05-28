import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vehicle_provider.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() =>
      _VehiclesScreenState();
}

class _VehiclesScreenState
    extends State<VehiclesScreen> {
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final plateController = TextEditingController();
  final colorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VehicleProvider>().fetchVehicles();
    });
  }

  void showAddVehicleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Vehicle',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: plateController,
                decoration: const InputDecoration(
                  labelText: 'Plate Number',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final provider =
                        context.read<VehicleProvider>();

                    final success =
                        await provider.createVehicle(
                      brand: brandController.text,
                      model: modelController.text,
                      plateNumber: plateController.text,
                      color: colorController.text,
                    );

                    if (!mounted) return;

                    if (success) {
                      brandController.clear();
                      modelController.clear();
                      plateController.clear();
                      colorController.clear();
                      Navigator.pop(context);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Vehicle added successfully'
                              : 'Failed to add vehicle',
                        ),
                      ),
                    );
                  },
                  child: const Text('Save Vehicle'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        actions: [
          IconButton(
            onPressed: showAddVehicleSheet,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.vehicles.isEmpty
              ? const Center(
                  child: Text('No vehicles added yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = provider.vehicles[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.directions_car),
                        ),
                        title: Text(
                          '${vehicle.brand} ${vehicle.model}',
                        ),
                        subtitle: Text(
                          '${vehicle.plateNumber} • ${vehicle.color}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}