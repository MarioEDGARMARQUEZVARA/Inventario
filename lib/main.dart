import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:inventario_proyecto/providers/mantenimento_provider.dart';
import 'package:inventario_proyecto/providers/session_provider.dart';
import 'package:inventario_proyecto/providers/transformadores2025_provider.dart';
import 'package:inventario_proyecto/providers/transformadoresxzona_provider.dart';
import 'package:inventario_proyecto/screens/authWrapper_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inicializar localización para fechas en español
  await initializeDateFormatting('es');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()), // SessionProvider PRIMERO
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
      // Usar el navigatorKey del SessionProvider
      navigatorKey: Provider.of<SessionProvider>(context, listen: false).navigatorKey,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      home: const AuthWrapper(),
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