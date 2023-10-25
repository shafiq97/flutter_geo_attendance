import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Admin/adminhome.dart';
import 'Home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  double _sigmaX = 5;
  bool isLoading = false;
  // from 0-10
  double _sigmaY = 5;

  // from 0-10
  double _opacity = 0.2;

  final _formKey = GlobalKey<FormState>();

  // sign user in method
  Future<void> signUserIn() async {
    if (_formKey.currentState!.validate()) {
      signInWithPassword();
    }
  }

  Future<void> signInWithPassword() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("logins")
          .doc("kTpMkcDpzuNKdVmX2KL7")
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        String? email = data?['email'] as String?;
        String? password = data?['password'] as String?;
        String? stud_id = data?["stud_id"] as String?;

        if (email != null && password != null && stud_id != null) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = userCredential.user;
          if (user != null) {
            print('Email: ${user.email}');
          }

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        UserId: stud_id,
                      )));
        } else {
          print('Email or password is missing in Firestore.');
        }
      } else {
        print('No data found in Firestore for the specified document.');
      }
    } catch (e) {
      print('Sign-in failed. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                  image: const AssetImage("assets/Image/login.jpg"),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AttendanceCheck()));
                      },
                      child: const Text("Admin")),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                  const Text("Log in",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 1)
                                  .withOpacity(_opacity),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Row(children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        // backgroundImage: AssetImage(
                                        //     "assets/Images/profile.jpg")
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      // Column(
                                      //   crossAxisAlignment:
                                      //   CrossAxisAlignment.start,
                                      //   // ignore: prefer_const_literals_to_create_immutables
                                      //   children: [
                                      //     Text("Jane Dow",
                                      //         style: TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 20,
                                      //             fontWeight: FontWeight.bold)),
                                      //     const SizedBox(height: 5),
                                      //     Text("jane.doe@gmail.com",
                                      //         style: const TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 18))
                                      //   ],
                                      // )
                                    ]),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter your email";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        label: Text("Email"),
                                        filled: true,
                                        fillColor: Colors.white),
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter your password";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Password"),
                                      fillColor: Colors
                                          .white, // Set the color you want
                                      filled:
                                          true, // Make sure the fill color is applied
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading =
                                                  true; // Set loading state to true
                                            });

                                            await signUserIn();

                                            setState(() {
                                              isLoading =
                                                  false; // Set loading state to false
                                            });
                                          },
                                    child: isLoading
                                        ? const CircularProgressIndicator() // Display circular progress indicator if loading
                                        : const Text("Continue"),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  const Text('Forgot Password?',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 71, 233, 133),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.start),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
