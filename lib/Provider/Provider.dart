import 'package:flutter/cupertino.dart';

import '../Model/Form.dart';

class FormDataProvider extends ChangeNotifier {
  FormData get formData => _formData;

  final FormData _formData = FormData(phoneNumber: "", email: "", regNo: "");

  // Getter methods to retrieve email, phone number, and registration number
  String getEmail() => _formData.email;
  String getPhoneNumber() => _formData.phoneNumber;
  String getRegNo() => _formData.regNo;

  void updateEmail(String newEmail) {
    _formData.email = newEmail;
    notifyListeners();
  }

  void updatePhoneNumber(String newphoneNumber) {
    _formData.phoneNumber = newphoneNumber;
    notifyListeners();
  }

  void updateRegNo(String newRegNo) {
    _formData.regNo = newRegNo;
    notifyListeners();
  }
}
