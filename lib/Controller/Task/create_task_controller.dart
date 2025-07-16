import 'dart:ui';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';

class CreateTaskController extends GetxController {
  RxBool isloading = false.obs;

  Future<void> createTask({
    required Map<String, dynamic> taskInfo,
    required String taskId,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      isloading.value = true;
      await Future.delayed(const Duration(milliseconds: 300));
      await DataBaseMethods().addTask(taskInfo, taskId);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
