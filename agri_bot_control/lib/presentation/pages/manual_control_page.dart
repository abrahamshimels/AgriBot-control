import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../shared/robot_globals.dart' as globals;

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({super.key});

  @override
  State<ManualControlPage> createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage> {
  bool isMoving = false;
  int speedLevel = 1;

  // ===== AUTO SERVO STATE =====
  bool autoServoEnabled = false;
  int openDelay = 2;
  int closeDelay = 2;

  Future<void> sendCommand(String endpoint) async {
    final url = "${globals.robotIP}/$endpoint";
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.wifi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connect to RC_CAR_WIFI before sending commands."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final request = http.Request('GET', Uri.parse(url));
      await request.send();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Command failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= MOVEMENT =================
  void move(String cmd) {
    sendCommand(cmd);
    setState(() => isMoving = cmd != "S");
  }

  // ================= SPEED =================
  void setSpeed(int level) {
    speedLevel = level;
    sendCommand(level == 10 ? "0" : level.toString());
    setState(() {});
  }

  // ================= SERVO =================
  void servo(String cmd) => sendCommand(cmd);

  // ================= AUTO SERVO LOGIC =================
  Future<void> startAutoServo() async {
    while (autoServoEnabled) {
      // Open servo (180°)
      await sendCommand("C");
      await Future.delayed(Duration(seconds: openDelay));

      if (!autoServoEnabled) break;

      // Close servo (0°)
      await sendCommand("A");
      await Future.delayed(Duration(seconds: closeDelay));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _movementCard(),
                  _speedCard(),
                  _servoCard(),
                  _autoServoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00A86B), Color(0xFF0056D2)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Text(
        "Robot Manual Control",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _movementCard() {
    return _card(
      title: "Movement",
      child: Column(
        children: [
          _iconBtn(Icons.arrow_upward, () => move("F")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconBtn(Icons.arrow_back, () => move("L")),
              const SizedBox(width: 20),
              _iconBtn(
                isMoving ? Icons.stop : Icons.play_arrow,
                () => move(isMoving ? "S" : "F"),
                big: true,
                color: isMoving ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 20),
              _iconBtn(Icons.arrow_forward, () => move("R")),
            ],
          ),
          _iconBtn(Icons.arrow_downward, () => move("B")),
        ],
      ),
    );
  }

  Widget _speedCard() {
    return _card(
      title: "Speed Control (Level $speedLevel)",
      child: Slider(
        min: 1,
        max: 10,
        divisions: 9,
        value: speedLevel.toDouble(),
        label: speedLevel.toString(),
        onChanged: (v) => setSpeed(v.round()),
      ),
    );
  }

  Widget _servoCard() {
    return _card(
      title: "Servo Control (Manual)",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _textBtn("0°", () => servo("A")),
          _textBtn("90°", () => servo("M")),
          _textBtn("180°", () => servo("C")),
        ],
      ),
    );
  }

  Widget _autoServoCard() {
    return _card(
      title: "Automatic Servo Control",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Open Delay (sec)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final value = int.tryParse(v);
                    if (value != null && value > 0) {
                      openDelay = value;
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Close Delay (sec)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    final value = int.tryParse(v);
                    if (value != null && value > 0) {
                      closeDelay = value;
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text("Automatic Open / Close"),
            subtitle: const Text("Servo cycles between 180° and 0°"),
            value: autoServoEnabled,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() => autoServoEnabled = value);
              if (value) startAutoServo();
            },
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(
    IconData icon,
    VoidCallback onTap, {
    bool big = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white,
          foregroundColor: Colors.black,
          shape: big
              ? const CircleBorder()
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.all(big ? 24 : 16),
          elevation: 6,
        ),
        onPressed: onTap,
        child: Icon(icon, size: big ? 36 : 28),
      ),
    );
  }

  Widget _textBtn(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
