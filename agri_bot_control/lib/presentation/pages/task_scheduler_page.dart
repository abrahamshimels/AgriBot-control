import 'package:flutter/material.dart';

class TaskSchedulerPage extends StatelessWidget {
  const TaskSchedulerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(), // Green-to-Blue Gradient Header
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendarCard(), // The December 2024 Calendar
                  const SizedBox(height: 25),
                  const Text(
                    "15 December",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildTaskItem(), // Sowing task details
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
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Task Scheduler",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Add New Task", style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_left, color: Colors.orange), onPressed: () {}),
              const Text("December 2024", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(icon: const Icon(Icons.arrow_right, color: Colors.orange), onPressed: () {}),
            ],
          ),
          // Simplified Grid for Calendar visualization
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: 31,
            itemBuilder: (context, index) {
              int day = index + 1;
              bool isSelected = day == 12; // Design Highlight
              bool isSecondarySelected = day == 15; // Design Highlight
              
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : (isSecondarySelected ? Colors.green.withOpacity(0.2) : Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isSecondarySelected ? Colors.green : Colors.black54),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.eco, color: Colors.green),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sowing", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("08:00 • Field A - North Section", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}