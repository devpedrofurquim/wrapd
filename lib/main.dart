import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrapd/app/app.dart';
import 'package:wrapd/core/di/service_locator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  // Keeps the splash screen up until manually removed
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  // Load environment variables (for GitHub OAuth, etc.)
  await dotenv.load(fileName: ".env");

  // Register dependencies
  setupLocator();
  // Remove splash after init is done

  FlutterNativeSplash.remove();

  runApp(const WrapdApp());
}
