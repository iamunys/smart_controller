// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_controller/constant/constant.dart';

class MutationControlls extends GetxController {
  late MutationStatus _status = MutationStatus.initial;

  MutationStatus get status => _status;

  set status(MutationStatus value) {
    _status = value;
    update();
  }
}

class MutationLoader extends StatelessWidget {
  const MutationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: Constant.bgSecondary,
        radius: 10,
      ),
    );
  }
}

enum MutationStatus { initial, loading, done, error }
