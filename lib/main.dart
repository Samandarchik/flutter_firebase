import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool get isRegistered => FirebaseAuth.instance.currentUser != null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: Builder(builder: (context) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.active) {
                  final isRegistered = snap.data != null;
                  return isRegistered
                      ? const HomePage()
                      : const RegisterOrLogin();
                }
                return const Scaffold();
              });
        }));
  }
}

class RegisterOrLogin extends StatefulWidget {
  const RegisterOrLogin({super.key});

  @override
  State<RegisterOrLogin> createState() => _RegisterOrLoginState();
}

class _RegisterOrLoginState extends State<RegisterOrLogin> {
  String email = "";
  String password = "";

  bool isLoding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auth"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
              child: isLoding
                  ? const CircularProgressIndicator.adaptive()
                  : Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(hintText: "Email"),
                          onChanged: (email) => this.email = email,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Password"),
                          onChanged: (password) => this.password = password,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoding = true;
                              });
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              setState(() {
                                isLoding = false;
                              });
                            },
                            child: Text("Login")),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoding = true;
                              });
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              setState(() {
                                isLoding = false;
                              });
                            },
                            child: Text("SingUp")),
                      ],
                    )),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 48),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text(
                  "SingOut",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
