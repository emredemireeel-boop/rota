import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'services/ad_free_purchase_service.dart';
import 'services/ad_mob_service.dart';
import 'services/interstitial_ad_service.dart';
import 'services/memory_store.dart';
import 'services/scratch_map_store.dart';
import 'theme/rota_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MemoryStore.instance.initialize();
  await ScratchMapStore.instance.initialize();
  await AdFreePurchaseService.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: RotaColors.paper,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const RotaApp());
}

class RotaApp extends StatefulWidget {
  const RotaApp({super.key});

  @override
  State<RotaApp> createState() => _RotaAppState();
}

class _RotaAppState extends State<RotaApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdMobService.instance.initialize();
      RotaInterstitialAdService.instance.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rota Dünya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RotaColors.ink,
          brightness: Brightness.light,
          primary: RotaColors.ink,
          secondary: RotaColors.forest,
          surface: RotaColors.paper,
        ),
        scaffoldBackgroundColor: RotaColors.cream,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: RotaColors.paper,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: RotaColors.ink,
          ),
          iconTheme: const IconThemeData(color: RotaColors.ink),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: RotaColors.paper,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF0EEE7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
