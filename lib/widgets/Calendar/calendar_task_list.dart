import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/widgets/Task/task_view_screen.dart';

class CalendarTaskList extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> taskStream;
  const CalendarTaskList({required this.taskStream, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final docs = snapshot.data?.docs ?? [];

        // ✅ Handle no tasks
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              "No Tasks Found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final task = docs[index];

            // ✅ Safe check for data (prevent crash)
            final data = task.data() as Map<String, dynamic>?;

            if (data == null || data.isEmpty) {
              return const SizedBox(); // skip empty or deleted doc
            }

            final id = task.id;
            final title = data["Title"] ?? "";
            final description = data["Description"] ?? "";
            // final isoDate = data["Date"] ?? "";
            final formatedDate = data["Formatted Date"] ?? "";
            final startTime = data["Start Time"] ?? "";
            final endTime = data["End Time"] ?? "";
            final category = data["Category"] ?? "";
            final sortableStartTime = data["Sortable Start Time"] ?? "";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => TaskViewScreen(
                            id: id,
                            title: title,
                            description: description,

                            startTime: startTime,
                            endTime: endTime,
                            category: category,
                            formattedDate: formatedDate,
                            sortableStartTime: sortableStartTime,
                          ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(startTime, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  formatedDate,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  startTime,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  endTime,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
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
