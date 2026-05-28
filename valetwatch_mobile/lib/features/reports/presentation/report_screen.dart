import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/services/location_service.dart';
import '../../../shared/models/report_type.dart';
import 'report_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportType selectedType = ReportType.fakeValet;

  final descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  bool hasLocation = false;
  double? latitude;
  double? longitude;

  File? selectedImage;

  Future<void> checkLocation() async {
    final position = await LocationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      hasLocation = position != null;
      latitude = position?.latitude;
      longitude = position?.longitude;
    });
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: hasLocation
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation ? Colors.green : Colors.orange,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasLocation ? Icons.location_on : Icons.location_off,
                    color: hasLocation ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hasLocation
                          ? 'Location detected. Your report will be linked to the nearest valet zone.'
                          : 'Location not detected. Tap refresh location.',
                    ),
                  ),
                  IconButton(
                    onPressed: checkLocation,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),

            if (hasLocation)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lat: ${latitude?.toStringAsFixed(6)}\nLng: ${longitude?.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),

            DropdownButtonFormField<ReportType>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
              items: ReportType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: Text(
                  selectedImage == null
                      ? 'Attach Photo Evidence'
                      : 'Photo Selected',
                ),
              ),
            ),

            if (selectedImage != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        final success = await provider.createReport(
                          reportType: selectedType.value,
                          description: descriptionController.text,
                          image: selectedImage,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Report submitted successfully'
                                  : 'Failed to submit report',
                            ),
                          ),
                        );

                        if (success) {
                          descriptionController.clear();

                          setState(() {
                            selectedImage = null;
                          });

                          await checkLocation();
                        }
                      },
                icon: const Icon(Icons.report),
                label: Text(
                  provider.isLoading ? 'Submitting...' : 'Submit Report',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}