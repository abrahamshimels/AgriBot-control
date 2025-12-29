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
  bool isSpraying = false;
  double speed = 0.0;

  /// Sends a command to the robot without waiting for full response.
  /// Shows instructions if not connected to Wi-Fi.
  Future<void> sendCommand(String endpoint) async {
    final url = "${globals.robotIP}/$endpoint";
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.wifi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please connect your device to the robot Wi-Fi (RC_CAR_WIFI) before sending commands.",
            maxLines: 3,
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final request = http.Request('GET', Uri.parse(url));
      await request.send();
      print("Command sent: $url");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Command sent to robot."),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error sending command: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending command: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void toggleMovement() {
    sendCommand(isMoving ? "S" : "F");

    setState(() {
      isMoving = !isMoving;
      speed = isMoving ? 1.5 : 0.0;
    });
  }

  void moveDirection(String dir) {
    if (!isMoving && dir != "Stop") return;

    switch (dir) {
      case "Forward":
        sendCommand("F");
        break;
      case "Backward":
        sendCommand("B");
        break;
      case "Left":
      case "Right":
        sendCommand("F"); // Update for differential turning if supported
        break;
      case "Stop":
        sendCommand("S");
        break;
    }
  }

  void toggleSpraying() {
    sendCommand(isSpraying ? "C" : "O");

    setState(() {
      isSpraying = !isSpraying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 20),
                  _buildDirectionalControl(),
                  const SizedBox(height: 20),
                  _buildSeedSprayingControl(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
      child: const Text(
        "Manual Control",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return _buildCardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Robot Status", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                isMoving ? "Moving" : "Stopped",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isMoving ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text("Speed", style: TextStyle(color: Colors.grey)),
              Text(
                "${speed.toStringAsFixed(1)} m/s",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionalControl() {
    return _buildCardWrapper(
      child: Column(
        children: [
          const Text(
            "Directional Control",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _directionBtn(Icons.arrow_upward, () => moveDirection("Forward")),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _directionBtn(Icons.arrow_back, () => moveDirection("Left")),
              const SizedBox(width: 20),
              _centerBtn(),
              const SizedBox(width: 20),
              _directionBtn(Icons.arrow_forward, () => moveDirection("Right")),
            ],
          ),
          const SizedBox(height: 10),
          _directionBtn(Icons.arrow_downward, () => moveDirection("Backward")),
        ],
      ),
    );
  }

  Widget _directionBtn(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 28),
    );
  }

  Widget _centerBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isMoving ? Colors.red : Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: const CircleBorder(),
        elevation: 8,
      ),
      onPressed: toggleMovement,
      child: Icon(isMoving ? Icons.stop : Icons.play_arrow, size: 30),
    );
  }

  Widget _buildSeedSprayingControl() {
    return _buildCardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue.shade300),
              const SizedBox(width: 10),
              const Text(
                "Seed Spraying",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Switch(
            value: isSpraying,
            onChanged: (_) => toggleSpraying(),
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
      ),
      child: child,
    );
  }
}
