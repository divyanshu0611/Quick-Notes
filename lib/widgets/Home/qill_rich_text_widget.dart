import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:quick_notes/Controller/Notes/note_editor_controller.dart';

class RichTextEditorCustomWidget extends StatelessWidget {
  const RichTextEditorCustomWidget({super.key, required this.controller});

  final NoteEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: RawScrollbar(
        minThumbLength: 20,
        controller: controller.scrollController,
        thumbVisibility: true,
        thickness: 4,
        thumbColor: Colors.black54,
        radius: const Radius.circular(6),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          scrollDirection: Axis.horizontal,
          child: QuillSimpleToolbar(
            controller: controller.quillController,
            config: const QuillSimpleToolbarConfig(
              axis: Axis.horizontal,
              toolbarSize: 3,
              toolbarRunSpacing: 0,
              showUndo: false,
              showRedo: false,
              showInlineCode: false,
              showCodeBlock: false,
              showLink: false,
              showSuperscript: false,
              showSubscript: false,
              showStrikeThrough: false,
              showQuote: false,
              showBackgroundColorButton: false,
              showFontFamily: false,
              showFontSize: false,
              showClearFormat: false,
              showHeaderStyle: false,
            ),
          ),
        ),
      ),
    );
  }
}
