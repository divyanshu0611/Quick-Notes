import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/Controller/Notes/note_editor_controller.dart';
import 'package:quick_notes/widgets/Home/qill_rich_text_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ⬅ Required for .w, .h, .sp

class NotesCreateScreen extends StatefulWidget {
  const NotesCreateScreen({super.key});

  @override
  State<NotesCreateScreen> createState() => _NotesCreateScreenState();
}

class _NotesCreateScreenState extends State<NotesCreateScreen> {
  // ✅ Injecting controller using GetX
  final NoteEditorController controller = Get.put(NoteEditorController());

  // ✅ Title input controller
  final TextEditingController titleController = TextEditingController();

  // ✅ Form validation key
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.initWithDocument(Document()); // empty doc for new note
  }

  @override
  void dispose() {
    // ✅ Always dispose controllers to avoid memory leaks

    titleController.dispose();
    super.dispose();
  }

  // ✅ Basic required validator
  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please fill this field";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          title: Text(
            "Create Note",
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
              onPressed: () async {
                final isValid = formKey.currentState!.validate();
                final plainText =
                    controller.quillController.document.toPlainText().trim();

                if (!isValid || plainText.isEmpty) {
                  Get.snackbar("Error", "Please enter title and description");
                  return;
                }

                // ✅ Generate unique ID for note
                final noteId = randomAlphaNumeric(10);

                final noteInfo = {
                  "Title": titleController.text.trim(),
                  "Description":
                      controller.quillController.document.toDelta().toJson(),
                };

                await DataBaseMethods().addNotes(noteInfo, noteId);

                Get.snackbar("Success", "Note created successfully!");

                titleController.clear();
                controller.quillController.document = Document();
                controller.focusNode.unfocus();

                Future.delayed(Duration(milliseconds: 300), () {
                  Get.delete<NoteEditorController>();
                });
              },
            ),
          ],
        ),

        body: Obx(() {
          // ✅ Wait for initialization (optional)
          if (!controller.isInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
                top: 12.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 100.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 📝 TITLE FIELD
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    textInputAction: TextInputAction.next,
                    validator: requiredValidator,
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
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// 🧠 RICH TEXT EDITOR
                  Container(
                    constraints: BoxConstraints(minHeight: 200.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: QuillEditor.basic(
                      controller: controller.quillController,
                      focusNode: controller.focusNode,
                      config: const QuillEditorConfig(
                        placeholder: "Write your note...",
                        showCursor: true,
                        expands: false,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  SizedBox(height: 100.h), // Spacer below editor
                ],
              ),
            ),
          );
        }),

        /// 🧰 TOOLBAR (Only visible when keyboard is open)
        bottomNavigationBar: Builder(
          builder: (context) {
            final keyboardVisible =
                MediaQuery.of(context).viewInsets.bottom > 0;

            if (!keyboardVisible) {
              return const SizedBox(); // Hide if keyboard closed
            }

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
