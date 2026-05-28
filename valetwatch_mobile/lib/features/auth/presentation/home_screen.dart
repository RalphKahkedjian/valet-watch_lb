import 'package:flutter/material.dart';

import '../../parking_sessions/presentation/start_session_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValetWatch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ValetWatch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Protect your car, verify valet zones, and report suspicious activity in Lebanon.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const StartSessionScreen(),
                      ),
                    );
                  },
                  child: const _ActionCard(
                    icon: Icons.local_parking,
                    title: 'Start Session',
                    subtitle: 'Park your vehicle',
                    color: Colors.blue,
                  ),
                ),

                const _ActionCard(
                  icon: Icons.report,
                  title: 'Report Issue',
                  subtitle:
                      'Fake valet or scam',
                  color: Colors.red,
                ),

                const _ActionCard(
                  icon: Icons.map,
                  title: 'View Map',
                  subtitle:
                      'Nearby valet zones',
                  color: Colors.green,
                ),

                const _ActionCard(
                  icon: Icons.camera_alt,
                  title: 'Evidence',
                  subtitle: 'Upload proof',
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Safety Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            const _TipCard(
              icon: Icons.qr_code,
              title:
                  'Ask for valet verification',
              description:
                  'Only trust valet workers connected to approved zones or official businesses.',
            ),

            const _TipCard(
              icon: Icons.payments,
              title:
                  'Check the official price',
              description:
                  'Valet pricing should be transparent before giving your car.',
            ),

            const _TipCard(
              icon: Icons.directions_car,
              title:
                  'Take photos before leaving',
              description:
                  'Capture your car condition and belongings before handing over the keys.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}