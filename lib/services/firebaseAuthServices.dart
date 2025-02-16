// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_controller/controller/Exceptions.dart';

class FirebaseAuthentication extends GetxController {
  // static final authInstance = FirebaseAuth.instance;

  static Future<User?> listenToAuthChange() async {
    await for (User? user in FirebaseAuth.instance.authStateChanges()) {
      if (user == null) {
        debugPrint('User is currently signed out! : $user');
        return null;
      } else {
        debugPrint('User is signed in! : $user');

        return user;
      }
    }
    return null;
  }

  static verifyPhoneNumber(String? phoneNumber, codeSent, verifyErr,
      {int? resendToken}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: verifyErr,
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('code sent');

          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: resendToken);
  }

  static signInWithPhoneAuthCredential(verificationId, smsCode) async {
    // Create a PhoneAuthCredential with the code

    // Sign the user in (or link) with the credential
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUSer = userCredential.additionalUserInfo!.isNewUser;
      String? userName = userCredential.additionalUserInfo!.username;
      String? authCode = userCredential.additionalUserInfo!.authorizationCode;
      String? proID = userCredential.additionalUserInfo!.providerId;
      debugPrint("Is that new user : $isNewUSer");
      debugPrint("userName : $userName");
      debugPrint("Auth Code : $authCode");
      debugPrint("Pro Id  : $proID");
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        throw UserException("Invalid OTP");
      }
    } catch (e) {
      throw UserException("Error while OTP verification.");
    }
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
