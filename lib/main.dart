import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/categories_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ImposterGameApp());
}

class ImposterGameApp extends StatelessWidget {
  const ImposterGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Guess the Imposter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
