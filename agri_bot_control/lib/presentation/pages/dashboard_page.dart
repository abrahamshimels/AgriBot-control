import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _HeaderSection(),
            SizedBox(height: 20),
            _QuickActions(),
            SizedBox(height: 20),
            _SensorSection(),
            SizedBox(height: 30),
            _QuickAccessSection(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/* ================= HEADER ================= */

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "AgroRobot Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _RobotStatusCard(),
        ],
      ),
    );
  }
}

class _RobotStatusCard extends StatelessWidget {
  const _RobotStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _statusIcon(Icons.memory),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Robot Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _statusIcon(Icons.wifi),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _StatusItem("Battery", "78%", Icons.battery_6_bar),
              _StatusItem("Solar", "45W", Icons.wb_sunny),
              _StatusItem("Moisture", "42%", Icons.water_drop),
            ],
          ),
          const Divider(color: Colors.white30, height: 28),
          const Text(
            "Location: 9.145°, 40.489°",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _statusIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatusItem(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/* ================= QUICK ACTIONS ================= */

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton("Start", Icons.play_arrow, Colors.green, () {
            context.go('/control');
          }),
          _ActionButton("Pause", Icons.pause, Colors.orange, () {
            context.go('/control');
          }),
          _ActionButton("Stop", Icons.stop, Colors.red, () {
            context.go('/control');
          }),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(this.label, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

/* ================= SENSOR DATA ================= */

class _SensorSection extends StatelessWidget {
  const _SensorSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _SensorCard("Spray", "68%", Colors.blue),
          _SensorCard("Seed", "55%", Colors.green),
          _SensorCard("Moisture", "42%", Colors.orange),
        ],
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SensorCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= QUICK ACCESS ================= */

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          _QuickTile(
            Icons.control_camera,
            "Control",
            Colors.green,
            "control",
          ),
          _QuickTile(Icons.bar_chart, "Analytics", Colors.blue, "alerts"),
          _QuickTile(Icons.battery_6_bar, "Battery", Colors.orange, "alerts"),
          _QuickTile(Icons.wb_sunny, "Solar", Colors.yellow, "dashboard"),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String path;

  const _QuickTile(this.icon, this.label, this.color, this.path);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.go('/$path');
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
