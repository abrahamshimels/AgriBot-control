import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';
import '../../shared/robot_globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ipController = TextEditingController(
    text: globals.robotIP,
  );
  final AuthController _authController = AuthController();

  double _currentSpeed = 3.0;
  String _operationMode = "Automatic";
  bool _wifiConnected = false;

  @override
  void initState() {
    super.initState();
    _checkWifiStatus();
  }

  Future<void> _checkWifiStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _wifiConnected = connectivityResult == ConnectivityResult.wifi;
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
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildRobotSettings(),
                const SizedBox(height: 20),
                _buildConnectivitySection(),
                const SizedBox(height: 20),
                _buildAboutSection(),
                const SizedBox(height: 30),
                _buildLogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00964A), Color(0xFF0056D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Text(
        "Settings",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // -------------------- Robot Settings --------------------
  Widget _buildRobotSettings() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings_suggest, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                "Robot Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Robot IP",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    hintText: "e.g., http://192.168.4.1",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final ip = _ipController.text.trim();
                  if (ip.isNotEmpty) {
                    globals.robotIP = ip;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Robot IP updated to $ip"),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
                child: const Text("Set"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Default Speed",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Slider(
            value: _currentSpeed,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            activeColor: Colors.green,
            label: "${_currentSpeed.round()} m/s",
            onChanged: (val) => setState(() => _currentSpeed = val),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("1 m/s", style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text("5 m/s", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Operation Mode",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _modeChip("Automatic"),
              const SizedBox(width: 10),
              _modeChip("Manual"),
              const SizedBox(width: 10),
              _modeChip("Eco Mode"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modeChip(String mode) {
    bool isSelected = _operationMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _operationMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // -------------------- Connectivity --------------------
  Widget _buildConnectivitySection() {
    return _buildCardWrapper(
      child: Column(
        children: [
          _statusRow(
            Icons.wifi,
            "Wi-Fi",
            _wifiConnected ? "Connected" : "Disconnected",
            _wifiConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 15),
          _statusRow(
            Icons.settings_input_antenna,
            "LoRa Network",
            "Connected",
            Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  Widget _statusRow(
    IconData icon,
    String label,
    String status,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(
          status,
          style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // -------------------- About --------------------
  Widget _buildAboutSection() {
    return _buildCardWrapper(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("App Version"),
              Text("1.2.5", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Robot Firmware"),
              Text("v2.0.8", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------- Logout --------------------
  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _authController.logout();
        context.go('/login');
      },
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // -------------------- Card Wrapper --------------------
  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
      ),
      child: child,
    );
  }
}
