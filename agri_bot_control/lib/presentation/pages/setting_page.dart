import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _currentSpeed = 3.0;
  String _operationMode = "Automatic";
  String _language = "English";

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
                _buildProfileSection(),
                const SizedBox(height: 20),
                _buildRobotSettings(),
                const SizedBox(height: 20),
                _buildConnectivitySection(),
                const SizedBox(height: 20),
                _buildLanguageSection(),
                const SizedBox(height: 20),
                _buildAboutSection(),
                const SizedBox(height: 30),
                _buildLogoutButton(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
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

  Widget _buildProfileSection() {
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
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                "Profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Farmer Name",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Text(
            "Abebe Kebede",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          const Text(
            "Phone Number",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Text(
            "+251 911 234 567",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

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

  Widget _buildConnectivitySection() {
    return _buildCardWrapper(
      child: Column(
        children: [
          _statusRow(Icons.wifi, "Wi-Fi", "Connected", Colors.orange),
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
        const Text(
          "Connected",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Colors.blue),
              const SizedBox(width: 12),
              const Text(
                "Language",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _langBtn("English"),
              const SizedBox(width: 10),
              _langBtn("Amharic (አማርኛ)"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _langBtn(String lang) {
    bool isSel = _language == lang;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSel
              ? Colors.green.withOpacity(0.1)
              : Colors.transparent,
          side: BorderSide(color: isSel ? Colors.green : Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => setState(() => _language = lang),
        child: Text(
          lang,
          style: TextStyle(color: isSel ? Colors.green : Colors.black),
        ),
      ),
    );
  }

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

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () {},
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

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 4,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports_outlined),
          label: "Control",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: "Alerts",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
