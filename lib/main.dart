import 'package:contact_app/notifier/contact_provider.dart';
import 'package:contact_app/view/home_screen.dart';
import 'package:contact_app/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FormProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SqlContactProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.isDark ? ThemeData.dark() : ThemeData.light(),
      title: "Contact App",
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "profile_page": (context) => ProfilePage(),
      },
    );
  }
}
