import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:noted_app/src/models/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noted_app/src/screens/home_screen.dart';
import 'package:noted_app/src/screens/log_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  final dir = await getApplicationSupportDirectory();

  final isar = await Isar.open(
    [NotesSchema],
    directory: dir.path
  );

  final note = Notes()
    ..title = "Test Note";
  
  await isar.writeTxn(() async {
    note.id = await isar.notes.put(note);
  });

  final allNotes = await isar.notes.where().findAll();

  print(allNotes);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = prefs.getBool("isLoggedIn");

  await Future.delayed(const Duration(seconds: 2)); 
  if(isLoggedIn == true) {
    runApp(const MyApp(home: HomeScreen()));
  } else {
    runApp(const MyApp(home: LoginScreen()));
  }
}

class MyApp extends StatefulWidget {

  final Widget home;

  const MyApp({
    Key? key,
    required this.home
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Noted",
      theme: ThemeData(
        fontFamily: "Inter",
      ),
      routes: {
        "/": (context) => widget.home,
        "home": (context) => const HomeScreen()
      }
    );
  }
}