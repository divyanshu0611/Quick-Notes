import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ Import screenutil
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/widgets/Task/task_view_screen.dart';

class MainTaskListWidget extends StatefulWidget {
  final String searchQuery;
  const MainTaskListWidget({super.key, required this.searchQuery});

  @override
  State<MainTaskListWidget> createState() => _MainTaskListWidgetState();
}

class _MainTaskListWidgetState extends State<MainTaskListWidget> {
  Stream? taskStream;

  @override
  void initState() {
    super.initState();
    loadCreatedTask();
  }

  // ✅ Load all created tasks from Firestore
  Future<void> loadCreatedTask() async {
    taskStream = await DataBaseMethods().getTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: \${snapshot.error}"));
        }

        // ✅ If no data, show animation
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Lottie.asset(
              "assets/animation/Animation - 1751452413882 (1).json",
              animate: true,
              repeat: true,
              height: Get.height,
              width: Get.width,
            ),
          );
        }

        // ✅ Filter tasks based on search
        final allTasks = snapshot.data.docs;
        final filteredTasks =
            widget.searchQuery.isEmpty
                ? allTasks
                : allTasks.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data['Title'] as String?)?.toLowerCase() ?? '';
                  return title.contains(widget.searchQuery);
                }).toList();

        // ✅ If filtered list is empty
        if (filteredTasks.isEmpty) {
          return Center(
            child: Text(
              "No matching tasks found",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ), // ✅ screenutil
            ),
          );
        }

        // ✅ List of tasks
        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            DocumentSnapshot task = filteredTasks[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 20.h), // ✅ screenutil
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TaskViewScreen(
                            id: task.id,
                            title: task['Title'] ?? "",
                            description: task['Description'] ?? "",
                            isoDate: task["Formatted Date"] ?? "",
                            startTime: task['Start Time'] ?? "",
                            endTime: task['End Time'] ?? "",
                            category: task['Category'] ?? "",
                            sortableStartTime:
                                task['Sortable Start Time'] ?? "",
                            formattedDate: task["Formatted Date"] ?? "",
                          ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: 130.h,
                        minHeight: 125.h,
                      ), // ✅ screenutil
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ), // ✅ screenutil
                        color: Colors.grey.withAlpha(40),
                        border: Border.all(width: 0.5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w, // ✅ screenutil
                        right: 10.w, // ✅ screenutil
                        bottom: 5.h,
                        top: 5.h, // ✅ screenutil
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ Title & Delete Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task["Title"] ?? "No Title",
                                  style: TextStyle(
                                    fontSize: 18.sp, // ✅ screenutil
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DataBaseMethods().deleteTask(task.id);
                                },
                                icon: Icon(
                                  Icons.delete_outline_sharp,
                                  size: 24.sp,
                                ), // ✅
                              ),
                            ],
                          ),

                          // ✅ Description
                          Text(
                            task["Description"] ?? "Description not available",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.sp, // ✅ screenutil
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Divider(),
                          SizedBox(height: 6.h), // ✅ screenutil
                          // ✅ Time & Category
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    task["Formatted Date"] ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp, // ✅
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10.w), // ✅
                                  Text(
                                    task["Start Time"] ?? "",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10.w), // ✅
                                  Text(
                                    task["End Time"] ?? "",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                ), // ✅
                                height: 30.h, // ✅
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(
                                    10.r,
                                  ), // ✅
                                ),
                                child: Center(
                                  child: Text(
                                    task["Category"] ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp, // ✅
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
