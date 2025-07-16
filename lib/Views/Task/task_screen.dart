import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ ScreenUtil added
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/widgets/Task/tasklist.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController taskSearchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Your Task",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24.sp, // 📱 Responsive font
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed:
                () => Get.offAllNamed(
                  AppRoutes.customBottomNavBar,
                  arguments: {'tabIndex': 0},
                ),
            icon: Icon(Icons.arrow_back, size: 28.sp), // 📱 Responsive icon
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w, // 📱 Responsive horizontal padding
            vertical: 10.h, // 📱 Responsive vertical padding
          ),
          child: Column(
            children: [
              CustomTextFormField(
                hintText: "Search Your Task",
                controller: taskSearchController,
                icon:
                    taskSearchController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            taskSearchController.clear();
                            setState(() {
                              searchQuery = "";
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            size: 25.sp,
                          ), // 📱 Responsive icon
                        )
                        : Icon(Icons.search, size: 25.sp), // 📱 Responsive icon
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 12.h), // 📱 Responsive spacing
              Expanded(
                child: SizedBox(
                  child: MainTaskListWidget(searchQuery: searchQuery),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          mini: true,
          autofocus: true,
          elevation: 50,
          onPressed: () {
            Get.toNamed(AppRoutes.taskCreateScreen);
          },
          child: Icon(
            Icons.task_alt_outlined,
            size: 30.sp, // 📱 Responsive FAB icon
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
