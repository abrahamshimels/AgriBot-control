import 'package:flutter/material.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AgriBot Control',
      routerConfig: appRouter,
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
