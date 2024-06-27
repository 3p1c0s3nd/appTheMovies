import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonata_cine/config/router/app_router.dart';
import 'package:sonata_cine/config/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: SonataCineApp()));
}

class SonataCineApp extends StatelessWidget {
  const SonataCineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Sonata Cine',
      theme: AppTheme().getTheme(),
    );
  }
}
