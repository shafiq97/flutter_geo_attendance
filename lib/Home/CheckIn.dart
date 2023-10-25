import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_attendance/Home/home.dart';
import 'package:sidebarx/sidebarx.dart';

import '../Login.dart';
import 'StudentProfile.dart';
import 'classes.dart';

class CheckIn extends StatefulWidget {
  final String stud_id;

  const CheckIn({super.key, required this.stud_id});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  String? barcode;
  String? userId;
  bool powerOff = false;
  DateTime? datetime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);


  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = "Failed to get platform Version";
    }
    if (barcodeScanRes != -1) {
      await sendScannedDataToFirebase(userId!, barcodeScanRes);
    }
    if (!mounted) return;
    setState(() {
      barcode = barcodeScanRes;
      datetime = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    userId = widget.stud_id;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("User logged out");
  }

// Send scanned data to Firebase Firestore
  Future<void> sendScannedDataToFirebase(
      String userId, String scannedData) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('scanned_data').add({
        "userId": userId,
        'scannedData': scannedData,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending barcode data to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
        //backgroundColor: Colors.lightGreen,
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black87,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Text("Press to Scan the QR code")),
            Container(
              child: IconButton(
                  onPressed: () async {
                    await barcodeScan();
                    setState(() {
                      powerOff = true;
                    });
                  },
                  icon: Icon(
                    powerOff
                        ? Icons.power_settings_new_outlined
                        : Icons.power_settings_new_outlined,
                    size: 150,
                    color: powerOff ? Colors.green : Colors.black38,
                  )),
            ),
            Container(
              child: ListTile(
                title: Text(powerOff
                    ? "Attendance Confirmed"
                    : "Please Confirm Your Attendance"),
                subtitle: Text(powerOff ? datetime.toString() : ""),
              ),
            )
          ],
        ),
        drawer: Container(
          width: we * 0.35,
          color: Colors.white,
          child: Column(children: [
            Container(
              //height: he * 0.17,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage("https://unsplash.com/photos/62wQhEghaw0"),
              ),
            ),
            Expanded(
              child: Container(
                width: we * 0.5,
                child: SidebarX(
                  controller: _controller,
                  items: [
                    SidebarXItem(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        icon: Icons.home,
                        label: 'Home'),
                    SidebarXItem(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Classes()));
                        },
                        icon: Icons.library_books,
                        label: 'My Classes'),
                    SidebarXItem(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                        icon: Icons.person,
                        label: 'Profile'),
                    SidebarXItem(icon: Icons.calendar_month, label: 'Calendar'),
                    SidebarXItem(icon: Icons.settings, label: "settings"),
                    SidebarXItem(
                        onTap: () {
                          signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        icon: Icons.logout,
                        label: 'Log Out'),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
