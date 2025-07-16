import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';

class TaskViewScreen extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String? isoDate; // Example: "2025-07-31"
  final String startTime;
  final String endTime;
  final String category;
  final String formattedDate; // Example: "31 July, 2025"

  const TaskViewScreen({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.formattedDate,
    this.isoDate, required sortableStartTime,
  });

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.title);
    _descCtrl = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  /// ✅ Update only title & description of the task
  Future<void> _updateTask() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final updatedData = {
      "Title": _titleCtrl.text.trim(),
      "Description": _descCtrl.text.trim(),
    };

    try {
      await DataBaseMethods().updateTask(updatedData, widget.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task Updated Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating task: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// 🗑️ Show confirmation and delete task
  Future<void> _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete this task?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await DataBaseMethods().deleteTask(widget.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task Deleted")));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 👈 Hide keyboard
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Task Details',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: _updateTask,
              icon: Icon(
                _isSaving ? Icons.hourglass_empty : Icons.check,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: _deleteTask,
              icon: Icon(Icons.delete, color: Colors.black, size: 24.sp),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // 🧾 Task details card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(35),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Title input field with leading icon
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 28.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextFormField(
                              controller: _titleCtrl,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Task Title',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24.h),

                      // 📅 Date
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: widget.formattedDate,
                      ),
                      SizedBox(height: 10.h),

                      // 🕒 Time
                      _InfoRow(
                        icon: Icons.access_time_outlined,
                        text: '${widget.startTime} – ${widget.endTime}',
                      ),
                      SizedBox(height: 16.h),

                      // 🏷️ Category
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.category,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // 📝 Description field
                TextFormField(
                  controller: _descCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  minLines: 10,
                  style: TextStyle(fontSize: 16.sp, height: 1.5),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withAlpha(35),
                    hintText: "Add your task description…",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🧩 Reusable row for date/time info
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp))),
      ],
    );
  }
}
