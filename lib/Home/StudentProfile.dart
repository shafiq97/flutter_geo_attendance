import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _emailController =
      TextEditingController(); // Controller for the name field
  final _passwordController =
      TextEditingController(); // Controller for the email field
  final _phoneNumberController =
      TextEditingController(); // Controller for the email field
  String initial_email = '';
  String initial_registrationNumber = "CT207/0041/19";
  String initial_phoneNumber = "0718705129";

  // Create an instance of your FormBloc
  void initState() {
    super.initState();

    // Assume your FormDataProvider contains methods to get the email, registration number, and phone number
    final formData = Provider.of<FormDataProvider>(context, listen: false);

    initial_email = formData
        .getEmail(); // replace getEmail() with the appropriate method from your Provider
    initial_registrationNumber =
        formData.getRegNo(); // similarly replace getRegNo()
    initial_phoneNumber = formData.getPhoneNumber(); // and getPhoneNumber()

    _emailController.text = initial_email;
    _passwordController.text = initial_registrationNumber;
    _phoneNumberController.text = initial_phoneNumber;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void showCustomDialog(BuildContext context) {
    final formData = Provider.of<FormDataProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Person Information'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Make the column take minimum height
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined), labelText: "Email"),
                onChanged: (email) {
                  formData.updateEmail(email);
                  setState(() {
                    initial_email = email;
                  });
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.password),
                    labelText: "RegistrationNumber"),
                onChanged: (regNo) {
                  formData.updateRegNo(regNo);
                  setState(() {
                    initial_registrationNumber = regNo;
                  });
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.text,
                //  initialValue: "Registration",
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.phone_android),
                    labelText: "PhoneNumber"),
                onChanged: (phoneNumber) {
                  formData.updatePhoneNumber(phoneNumber);
                  setState(() {
                    initial_phoneNumber = phoneNumber;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                initial_email = _emailController.text;
                initial_registrationNumber = _passwordController.text;
                initial_phoneNumber = _phoneNumberController.text;
                // Close the dialog when the "Close" button is pressed.
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blueAccent,
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        width: we,
        height: he,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: we,
                height: he * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: we,
                      height: he * 0.07,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.deepOrange),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.5),
                            // Adjust the color and opacity as needed
                            spreadRadius: 8,
                            // Spread radius for the glow effect
                            blurRadius: 20, // Blur radius for the glow effect
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/Image/profile.jpg"),
                        backgroundColor: Colors
                            .transparent, // Set the background color to transparent
                      ),
                    ),
                    Container(
                      width: 200,
                      height: he * 0.04,
                      child: const Center(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              "Devshi Deno,",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          subtitle:
                              Center(child: Text("Active since. Jul 2019")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: he * 0.02,
              ),
              ListTile(
                  title: const Text(
                    "Personal Information",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  trailing: TextButton(
                      onPressed: () {
                        showCustomDialog(context);
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.indigoAccent),
                      ))),
              // SizedBox(
              //   height: he * 0.02,
              // ),
              StudentForm(
                we: we,
                email: initial_email,
                registrationNumber: initial_registrationNumber,
                phoneNumber: initial_phoneNumber,
              ),
              const ListTile(
                title: Text(
                  "Utilities",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              StudentSubjects(we: we)
            ],
          ),
        ),
      ),
    );
  }
}

class StudentForm extends StatefulWidget {
  const StudentForm({
    super.key,
    required this.we,
    required this.email,
    required this.registrationNumber,
    required this.phoneNumber,
  });

  final String email;
  final String registrationNumber;
  final String phoneNumber;
  final double we;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: widget.we,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text("Email", style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    widget.email,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: widget.we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text("PhoneNumber",
                      style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    widget.phoneNumber.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: widget.we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Registration",
                      style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    widget.registrationNumber,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: widget.we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: const Center(
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title:
                      Text("Location", style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    "Nairobi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: widget.we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: const Center(
                child: ListTile(
                  leading: Icon(Icons.online_prediction_sharp),
                  title: Text("Status", style: TextStyle(color: Colors.white)),
                  trailing: Text(
                    "online",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StudentSubjects extends StatelessWidget {
  const StudentSubjects({
    super.key,
    required this.we,
  });

  final double we;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.question_mark),
                  title: const Text("Ask Help-Desk",
                      style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text("Add Subject",
                      style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: we,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
              child: const Center(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("LogOut", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
