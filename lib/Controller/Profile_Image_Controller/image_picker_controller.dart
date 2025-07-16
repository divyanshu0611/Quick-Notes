import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  RxString imagePath = "".obs;
  RxBool isPicking = false.obs; // 🔒 Lock flag

  final ImagePicker _picker = ImagePicker();

  Future<void> getProfileImage() async {
    if (isPicking.value) return; // ⛔ Prevent multiple taps

    try {
      isPicking.value = true;

      final XFile? profileImage =
          await _picker.pickImage(source: ImageSource.gallery);

      if (profileImage != null) {
        imagePath.value = profileImage.path;
      }
    } catch (e) {
      Get.snackbar("Image Picker Error", "$e");
    } finally {
      isPicking.value = false; // 🔓 Unlock
    }
  }
}
