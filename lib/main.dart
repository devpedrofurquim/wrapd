import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrapd/app/app.dart';
import 'package:wrapd/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (for GitHub OAuth, etc.)
  await dotenv.load(fileName: ".env");

  // Register dependencies
  setupLocator();

  runApp(const WrapdApp());
}
