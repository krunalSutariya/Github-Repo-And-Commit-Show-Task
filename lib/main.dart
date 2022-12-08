import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/repository_provider.dart';
import './screens/free_code_camp_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Github proivder....
        ChangeNotifierProvider.value(value: GithubProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FreeCodeRepositoryScreen(),
      ),
    );
  }
}
