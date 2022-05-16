import 'package:aaha/services/agencyManagement.dart';
import 'services/packageManagement.dart';
import 'package:provider/provider.dart';
import 'package:aaha/services/packageManagement.dart';
import 'package:aaha/services/travellerManagement.dart';
import 'package:flutter/material.dart';
import 'mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAtN39RIKKARPM3pdZ9LipIkX0FLGnm45s", // Your apiKey
      appId: "1:99687925149:android:527af34c12272e38885b74", // Your appId
      messagingSenderId: "99687925149", // Your messagingSenderId
      projectId: "assignment4-e9d53", // Your projectId
      storageBucket:"assignment4-e9d53.appspot.com",
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => travellerProvider()),
        ChangeNotifierProvider(create: (_) => agencyProvider()),
        ChangeNotifierProvider(create: (_) => packageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new mainScreen(),
    );
  }
}




