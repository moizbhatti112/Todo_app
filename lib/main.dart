import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_practice/Screens/home.dart';
import 'package:todo_practice/dataholder/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Tododata(),
      builder: (context, child) => 
      MaterialApp(
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(  
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

