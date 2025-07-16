import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/Controller/Notes/note_editor_controller.dart';
import 'package:quick_notes/widgets/Home/qill_rich_text_widget.dart';

class NoteViewScreen extends StatefulWidget {
  final String id;
  final String? title;
  final List<dynamic> descriptionDelta;

  const NoteViewScreen({
    super.key,
    required this.id,
    this.title,
    required this.descriptionDelta,
  });

  @override
  State<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late final NoteEditorController controller;
  late final TextEditingController titleController;
  final GlobalKey<FormState> formKey = GlobalKey(); // ✅ Form validation

  @override
  void initState() {
    super.initState();

    // ✅ Convert delta to Quill document
    final doc = _parseDelta(widget.descriptionDelta);

    // ✅ Register controller with GetX
    controller = Get.put(NoteEditorController());

    // ✅ Initialize Quill with document
    controller.initWithDocument(doc);

    // ✅ Set title input
    titleController = TextEditingController(text: widget.title);
  }

  // ✅ Parse Firestore delta
  Document _parseDelta(List<dynamic> delta) {
    try {
      return Document.fromJson(List<Map<String, dynamic>>.from(delta));
    } catch (e) {
      debugPrint("Delta parse error: $e");
      return Document();
    }
  }

  @override
  void dispose() {
    titleController.dispose(); // Only dispose your controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Dismiss keyboard when tapped outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Edit Note",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: controller.undo,
              tooltip: 'Undo',
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: controller.redo,
              tooltip: 'Redo',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Save',
              onPressed: () async {
                if (formKey.currentState == null ||
                    !formKey.currentState!.validate()) {
                  Get.snackbar("Error", "Please enter title and description");
                  return;
                }

                final plainText =
                    controller.quillController.document.toPlainText().trim();
                if (plainText.isEmpty) {
                  Get.snackbar("Error", "Please enter title and description");
                  return;
                }

                final noteInfo = {
                  "Title": titleController.text.trim(),
                  "Description":
                      controller.quillController.document.toDelta().toJson(),
                };

                await DataBaseMethods().updateNotes(noteInfo, widget.id);
                Get.back();

                Get.snackbar("Success", "Note updated!");

                Future.delayed(const Duration(milliseconds: 300), () {
                  Get.delete<NoteEditorController>();
                });
              },
            ),
          ],
        ),

        // ✅ Body content
        body: Obx(() {
          if (!controller.isInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 10.h,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📝 Title Input
                      TextFormField(
                        controller: titleController,
                        cursorColor: Colors.black,
                        cursorWidth: 1.w,
                        textInputAction: TextInputAction.next,
                        validator:
                            (val) => val!.isEmpty ? "Please enter title" : null,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Title",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // ✏️ Rich Text Editor
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: QuillEditor.basic(
                          controller: controller.quillController,
                          focusNode: controller.focusNode,
                          config: const QuillEditorConfig(
                            placeholder: "Write your note...",
                            showCursor: true,
                            expands: false,
                            padding: EdgeInsets.zero,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),

        // 📌 Show toolbar only when keyboard is open
        bottomNavigationBar: Builder(
          builder: (context) {
            final keyboardVisible =
                MediaQuery.of(context).viewInsets.bottom > 0;

            if (!keyboardVisible) return const SizedBox();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
                left: 2.w,
                right: 2.w,
              ),
              child: RichTextEditorCustomWidget(controller: controller),
            );
          },
        ),
      ),
    );
  }
}
