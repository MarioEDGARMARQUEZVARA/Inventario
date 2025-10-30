import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:inventario_proyecto/providers/mantenimento_provider.dart';
import 'package:inventario_proyecto/providers/transformadores2025_provider.dart';
import 'package:inventario_proyecto/providers/transformadoresxzona_provider.dart';
import 'package:inventario_proyecto/screens/authWrapper_screen.dart';
import 'package:inventario_proyecto/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MantenimientoProvider()),
        ChangeNotifierProvider(create: (_) => TransformadoresxZonaProvider()),
        ChangeNotifierProvider(create: (_) => Transformadores2025Provider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JQ7B - MEMV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // habilita español
      ],
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      routes: {
        '/': (context) => const AuthWrapper(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String fechaActual;

  @override
  void initState() {
    super.initState();
    // aquí conviertes la fecha a español
    fechaActual = DateFormat.yMMMMd('es').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fechas en español')),
      body: Center(child: Text(fechaActual)),
    );
  }
}
