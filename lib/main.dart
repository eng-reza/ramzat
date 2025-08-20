import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:passvault/consts/theme.dart';
import 'package:provider/provider.dart';
import 'consts/consts.dart';
import 'provider/addpasswordprovider.dart';
import 'provider/authprovider.dart';
import 'provider/generatedpassswordprovideer.dart';
import 'provider/navbarprovider.dart';
import 'provider/onboardprovider.dart';
import 'provider/themeprovider.dart';
import 'screens/auth/login.dart';
import 'screens/onboardingpage.dart';
import 'services/databaseservice.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//for future update versions v.2.0.0
//TODO:: Add Custom Word in Password Generator
//user can choose which authentication user will use to login.
//1.master password 2.fingerprint 3.password,4.google/apple
//TODO:: Fingerprint login & device password login
//TODO:: implement google/apple Authentication
//TODO:: Authentication option in settings
//TODO:: implement Backup and restore Password (Required google/apple Authentication)

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return ThemeProvider(context);
          }),
          ChangeNotifierProvider(create: (_) {
            return OnBoardingProvider();
          }),
          ChangeNotifierProvider(create: (_) {
            return NavBarProvider();
          }),
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DatabaseService(),
          ),
          ChangeNotifierProvider(
            create: (context) => AddPasswordProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => GeneratedPasswordProvider(),
          ),
        ],
        builder: (context, child) {
          removesplash();
          return Consumer<ThemeProvider>(builder: (
            context,
            value,
            child,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: Consts.APP_NAME,
              // theme: Styles.themeData(
              //   context: context,
              //   isDarkTheme: false,
              // ),
              // darkTheme: Styles.themeData(
              //   context: context,
              //   isDarkTheme: true,
              // ),
              theme: lightTheme,
              darkTheme: darkTheme,
              locale: const Locale('fa', 'IR'), // 👈 فارسی
              supportedLocales: const [
                Locale('fa', 'IR'),
                Locale('en', 'US'), // اگه بعداً انگلیسی هم خواستی
              ],
              localizationsDelegates: const [
                // برای پشتیبانی از ترجمه و تاریخ فارسی
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: context.watch<ThemeProvider>().themeMode,
              home: context.watch<OnBoardingProvider>().isBoardingCompleate
                  ? const LoginPage()
                  : const OnBoardingSceen(),
            );
          });
        });
  }

  void removesplash() async {
    return await Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove();
    });
  }
}
