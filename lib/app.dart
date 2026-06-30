import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'router.dart';

/// Root application widget.
class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: buildPulseTheme(),
      routerConfig: appRouter,
    );
  }
}
