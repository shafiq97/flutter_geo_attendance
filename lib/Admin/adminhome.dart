import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class AttendanceCheck extends StatefulWidget {
  const AttendanceCheck({super.key});

  @override
  State<AttendanceCheck> createState() => _AttendanceCheckState();
}

class _AttendanceCheckState extends State<AttendanceCheck> {
  final upiDetailsWithoutAmount = UPIDetails(
    upiID: "12345678",
    payeeName: "Test Account",
    transactionNote: "Attendance Confirmed",
  );
  List<Map<String, dynamic>> attendanceList = [];

  void initState() {
    getScannedData();
    super.initState();
  }

  Future<void> getScannedData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("scanned_data").get();
      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> data = snapshot.docs
            .map((doc) => {
                  "UserId": doc["userId"].toString(),
                  "timestamp": doc["timestamp"] as Timestamp
                })
            .toList();
        setState(() {
          attendanceList = data;
        });
      } else {
        print("No documents found in 'scanned_data' collection.");
      }
    } catch (e) {
      print("Failed to get scanned data details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendance List"),
        ),
        body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: UPIPaymentQRCode(
                upiDetails: upiDetailsWithoutAmount,
                size: 220,
                upiQRErrorCorrectLevel: UPIQRErrorCorrectLevel.low,
              ),
            ),
            Text(
              "Scan QR to Corfirm Attendace",
              style: TextStyle(color: Colors.grey[600], letterSpacing: 1.2),
            ),
            Expanded(
              child: attendanceList.isEmpty
                  ? Center(child: Text("No Student joined"))
                  : ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(attendanceList[index]["UserId"].toString()),
                          subtitle: Text(
                            attendanceList[index]["timestamp"]
                                .toDate()
                                .toString(),
                          ),
                        );
                      },
                    ),
            ),
          ]),
        ));
  }
}
