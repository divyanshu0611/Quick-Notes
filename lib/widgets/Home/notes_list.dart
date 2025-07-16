import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/Views/Notes/note_view_screen.dart';

class NotesTab extends StatefulWidget {
  final String searchQuery;

  const NotesTab({super.key, required this.searchQuery});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  Stream? notesStream;

  @override
  void initState() {
    super.initState();
    loadCreatedNotes(); // Load notes stream from Firestore
  }

  // 📥 Load notes from Firestore and assign to notesStream
  Future<void> loadCreatedNotes() async {
    final stream = await DataBaseMethods().getNotes();
    if (mounted) {
      setState(() {
        notesStream = stream;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌀 If notes stream is null, show loader
    if (notesStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: notesStream,
      builder: (context, AsyncSnapshot snapshot) {
        // 🔄 While waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ If there's an error in fetching
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 📭 If there are no notes
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Lottie.asset(
              "assets/animation/Animation - 1751452413882 (1).json",
              height: Get.height,
              width: Get.width,
            ),
          );
        }

        final notes = snapshot.data.docs;

        // 🔍 Filter notes by search query
        final filteredNotes =
            widget.searchQuery.isEmpty
                ? notes
                : notes.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data['Title'] as String?)?.toLowerCase() ?? '';
                  return title.contains(widget.searchQuery.toLowerCase());
                }).toList();

        // ❗ If search returns no matches
        if (filteredNotes.isEmpty) {
          return Center(
            child: Text(
              "No matching notes found",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          );
        }

        // 🧱 Display notes in a masonry grid
        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          shrinkWrap: true,
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final doc = filteredNotes[index];
            final data = doc.data() as Map<String, dynamic>;

            final title = (data['Title'] as String?) ?? 'No Title';
            final raw = data['Description'];

            // 🧠 Parse Quill Delta format safely
            List<dynamic> deltaList;
            try {
              if (raw is String && raw.trim().isNotEmpty) {
                deltaList = jsonDecode(raw) as List<dynamic>;
              } else if (raw is List) {
                deltaList = raw;
              } else {
                deltaList = [
                  {"insert": "\n"},
                ];
              }
            } catch (_) {
              deltaList = [
                {"insert": "\n"},
              ];
            }

            // 📝 Convert parsed delta to a Quill Document
            final document = Document.fromJson(
              List<Map<String, dynamic>>.from(deltaList),
            );

            // 🧱 Build each note card
            return InkWell(
              onLongPress: () {
                // 🗑️ Show delete confirmation dialog
                Get.defaultDialog(
                  title: "Delete Note",
                  middleText: "Are you sure you want to delete this note?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  onConfirm: () {
                    DataBaseMethods().deleteNotes(doc.id);
                    Get.back();
                    Get.snackbar(
                      "Note Deleted",
                      "Your note has been deleted successfully",
                      duration: const Duration(seconds: 2),
                    );
                  },
                );
              },
              onTap: () {
                // 👉 Navigate to NoteViewScreen on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => NoteViewScreen(
                          id: doc.id,
                          title: title,
                          descriptionDelta: deltaList,
                        ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // only takes necessary height
                  children: [
                    // 📌 Title Text
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // 📖 Rich Text Editor (Read-only mode for preview)
                    QuillEditor(
                      controller: QuillController(
                        document: document,
                        selection: const TextSelection.collapsed(offset: 0),
                        readOnly: true, // disables editing
                      ),
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                      config: QuillEditorConfig(
                        scrollable: true,
                        showCursor: false,
                        padding: EdgeInsets.zero,
                        scrollBottomInset: 10,
                        maxHeight: 280.h, // your original value preserved
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
