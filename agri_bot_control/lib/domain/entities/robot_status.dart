class RobotStatus {
  final int battery; // 78% [cite: 15]
  final int solarInput; // 45W [cite: 15]
  final String location; // 9.145, 40.489 [cite: 16]
  final String currentTask; // Idle [cite: 19]

  RobotStatus({
    required this.battery,
    required this.solarInput,
    required this.location,
    required this.currentTask,
  });
}
