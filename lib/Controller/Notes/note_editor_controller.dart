import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class NoteEditorController extends GetxController {
  late QuillController quillController;
  final focusNode = FocusNode();
  final scrollController = ScrollController();

  var isInitialized = false.obs;

  /// ✅ Initialize with a custom document (for create/edit screens)
  void initWithDocument(Document document) {
    quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    isInitialized.value = true;
  }

  /// ✅ Undo only if controller is not closed and has history
  void undo() {
    if (!isClosed && quillController.hasUndo) {
      quillController.undo();
    }
  }

  /// ✅ Redo only if controller is not closed and has history
  void redo() {
    if (!isClosed && quillController.hasRedo) {
      quillController.redo();
    }
  }

  @override
  void onClose() {
    // ✅ Clean up resources
    quillController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
