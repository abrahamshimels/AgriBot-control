import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildNotificationTile(
                  icon: Icons.check_box,
                  iconColor: Colors.green,
                  category: "Task",
                  time: "1h ago",
                  message: "Sowing task completed successfully in Field A",
                ),
                const SizedBox(height: 15),
                _buildNotificationTile(
                  icon: Icons.build,
                  iconColor: Colors.blue,
                  category: "Maintenance",
                  time: "2h ago",
                  message: "Reminder: Clean spray nozzles - Due in 2 days",
                ),
                const SizedBox(height: 15),
                _buildNotificationTile(
                  icon: Icons.battery_charging_full,
                  iconColor: Colors.lightGreen,
                  category: "Battery",
                  time: "3h ago",
                  message: "Battery level healthy at 78%",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00964A), Color(0xFF0056D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                "Alerts & Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildCountBox("3", "All"),
              const SizedBox(width: 15),
              _buildCountBox("2", "Unread"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBox(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51), // 0.2 opacity
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required Color iconColor,
    required String category,
    required String time,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  