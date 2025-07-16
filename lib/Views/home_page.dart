import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/widgets/Home/notes_list.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController notesSearchController = TextEditingController();
  final DataBaseMethods dataBaseMethods = DataBaseMethods();

  String searchQuery = ""; // 🔍 For search filtering
  late final String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    notesSearchController.dispose(); // 🧹 Prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap:
            () => FocusScope.of(context).unfocus(), // 🧼 Hide keyboard on tap
        child: Scaffold(
          extendBody: true,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👋 Greeting & Profile Image
                FutureBuilder<Map<String, dynamic>?>(
                  future: dataBaseMethods.getUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    final data = snapshot.data;
                    final imageUrl = data?['profileImageUrl'];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${data?['firstName'] ?? 'User'}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              (imageUrl != null && imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage(
                                        "assets/images/default_avatar.png",
                                      )
                                      as ImageProvider,
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 10.h),

                /// 🔍 Search Bar
                CustomTextFormField(
                  hintText: "Search Notes",
                  controller: notesSearchController,
                  icon:
                      notesSearchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.close, size: 22.sp),
                            onPressed: () {
                              notesSearchController.clear();
                              setState(() => searchQuery = "");
                            },
                          )
                          : Icon(Icons.search, size: 22.sp),
                  onChanged: (val) {
                    setState(() => searchQuery = val.toLowerCase());
                  },
                ),

                SizedBox(height: 12.h),

                /// 🗂️ Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffAFAFAF),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                /// 📃 Notes List
                Expanded(child: NotesTab(searchQuery: searchQuery)),
              ],
            ),
          ),

          /// ➕ FAB for creating new notes
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            mini: true,
            elevation: 30,
            onPressed: () => Get.toNamed(AppRoutes.notesCreateScreen),
            child: Icon(Icons.note_add, size: 30.sp, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
