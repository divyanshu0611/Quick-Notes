// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_notes/Controller/Task/create_task_controller.dart';
import 'package:quick_notes/widgets/Task/label_text_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({super.key});

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // 📌 Controllers for form fields
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final categoryController = TextEditingController();

  // 📌 State variables
  String? selectedCategory;
  String? sortableStartTime;

  // ✅ Initialize controllers
  final CreateTaskController taskController = Get.put(CreateTaskController());

  // 📌 Default category list
  final List<String> categories = [
    "Work",
    "Personal",
    "Study",
    "Exercise",
    "Shopping",
    "Travel",
    "Health",
  ];

  // 📌 Label styling
  final labelStyle = TextStyle(
    fontSize: 16.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: "Poppins",
  );

  @override
  void dispose() {
    // ✅ Clean up controllers
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // ➕ Add new category to list
  void addCategory() {
    String newCategory = categoryController.text.trim();
    if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
      setState(() {
        categories.add(newCategory);
        categoryController.clear();
      });
    }
  }

  // 📅 Pick and display date
  Future<void> pickDate() async {
    final datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (datePicked != null) {
      // 👉 Store human-readable date in controller (UI)
      dateController.text = DateFormat('d MMMM, y', 'en_US').format(datePicked);
    }
  }

  // ⏰ Pick and format start time
  Future<void> pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      startTimeController.text = time.format(context);
      sortableStartTime =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
  }

  // ⏰ Pick end time
  Future<void> pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      endTimeController.text = time.format(context);
    }
  }

  // ✅ Create task logic
  Future<void> createTask() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      showSnack("Please select a category");
      return;
    }

    if (sortableStartTime == null) {
      showSnack("Please pick a start time");
      return;
    }

    // 📌 Convert "25 July, 2025" ➜ "2025-07-25"
    late String isoDate;
    try {
      final parsedDate = DateFormat(
        'd MMMM, y',
        'en_US',
      ).parse(dateController.text.trim());
      isoDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      showSnack("Invalid or missing date");
      return;
    }

    // 🔐 Generate unique task ID
    final taskId = randomAlphaNumeric(10);

    // 📦 Prepare data map
    final taskInfo = {
      "Title": taskTitleController.text.trim(),
      "Description": taskDescriptionController.text.trim(),
      "Date": isoDate, // 🔑 used by calendar filtering
      "Formatted Date": dateController.text.trim(), // 🔠 shown in UI
      "Start Time": startTimeController.text.trim(),
      "End Time": endTimeController.text.trim(),
      "Category": selectedCategory,
      "Sortable Start Time": sortableStartTime!,
    };

    taskController.createTask(
      taskInfo: taskInfo,
      taskId: taskId,
      onSuccess: () {
        showSnack("Task Created Successfully");
        clearForm();
        Get.back(); // Close the create task page
      },
      onError: (error) {
        debugPrint("❌ Firestore error: $error");
        showSnack("Failed to create task: $error");
      },
    );
  }

  // 🍭 Show a snackbar message
  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ♻️ Clear form fields
  void clearForm() {
    taskTitleController.clear();
    taskDescriptionController.clear();
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    categoryController.clear();
    setState(() {
      selectedCategory = null;
      sortableStartTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ Hide keyboard
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Task",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.close, size: 30.sp, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelTextWidget(labelStyle: labelStyle, text: "Title"),
                    CustomTextFormField(
                      hintText: "Enter Title",
                      controller: taskTitleController,
                      validator: requiredValidator,
                    ),
                    SizedBox(height: 20.h),

                    LabelTextWidget(labelStyle: labelStyle, text: "Date"),
                    CustomTextFormField(
                      hintText: "Click here to select date",
                      controller: dateController,
                      readOnly: true,
                      onTap: pickDate,
                      validator: requiredValidator,
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelTextWidget(
                                labelStyle: labelStyle,
                                text: "Start Time",
                              ),
                              CustomTextFormField(
                                hintText: "Start",
                                controller: startTimeController,
                                readOnly: true,
                                onTap: pickStartTime,
                                validator: requiredValidator,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelTextWidget(
                                labelStyle: labelStyle,
                                text: "End Time",
                              ),
                              CustomTextFormField(
                                hintText: "End",
                                controller: endTimeController,
                                readOnly: true,
                                onTap: pickEndTime,
                                validator: requiredValidator,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    LabelTextWidget(
                      labelStyle: labelStyle,
                      text: "Description",
                    ),
                    CustomTextFormField(
                      hintText: "Enter Description",
                      controller: taskDescriptionController,
                      validator: requiredValidator,
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.h),

                    LabelTextWidget(
                      labelStyle: labelStyle,
                      text: "Add Category",
                    ),
                    CustomTextFormField(
                      hintText: "Add Category",
                      controller: categoryController,
                      icon: IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 22.sp),
                        onPressed: addCategory,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // 🔘 Category Chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 5.h,
                      children:
                          categories.map((category) {
                            final isSelected = selectedCategory == category;
                            return InputChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.grey.shade200,
                              onSelected:
                                  (_) => setState(() {
                                    selectedCategory =
                                        isSelected ? null : category;
                                  }),
                              onDeleted:
                                  () => setState(() {
                                    categories.remove(category);
                                    if (selectedCategory == category) {
                                      selectedCategory = null;
                                    }
                                  }),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 30.h),
                    Obx(
                      () =>
                          taskController.isloading.value
                              ? Center(child: CircularProgressIndicator())
                              : CustomButton(
                                title: "Create Task",
                                onTap: createTask,
                              ),
                    ),

                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget categorySection() {
    return Column(children: []);
  }

  // 📍 Basic form validator
  String? requiredValidator(String? value) =>
      (value == null || value.trim().isEmpty) ? "Please fill this field" : null;
}
