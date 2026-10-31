import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!FirebaseConfig.isConfigured) {
    runApp(const ConfigErrorApp());
    return;
  }

  await Firebase.initializeApp(options: FirebaseConfig.options);
  runApp(const TabletStoreApp());
}
