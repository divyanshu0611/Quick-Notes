import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseMethods {
  // 🔹 Add a task for the current user
  Future<void> addTask(Map<String, dynamic> taskInfoMap, String id) {
    // Get the current logged-in user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Navigate to: UserProfile/{userId}/Tasks/{id} and set the task data
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .doc(id)
        .set(taskInfoMap);
  }

  // 🔹 Get all tasks for the current user as a real-time stream
  Future<Stream<QuerySnapshot>> getTask() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Listen to all tasks under the user's "Tasks" subcollection
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .snapshots();
  }

  // 🔹 Update a task with new data
  Future<void> updateTask(Map<String, dynamic> taskInfoMap, String id) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Update task by ID in the user's "Tasks" subcollection
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .doc(id)
        .update(taskInfoMap);
  }

  // 🔹 Delete a task from Firestore
  Future<void> deleteTask(String id) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Delete the task document with the given ID
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .doc(id)
        .delete();
  }

  // ---------------------------------------------------------------
  // 🔹 Notes Section (Same structure as Tasks, but under "Notes")
  // ---------------------------------------------------------------

  // 🔹 Add a note for the current user
  Future<void> addNotes(Map<String, dynamic> notesInfoMap, String id) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Save the note to: UserProfile/{userId}/Notes/{id}
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Notes")
        .doc(id)
        .set(notesInfoMap);
  }

  // 🔹 Get all notes as a real-time stream
  Future<Stream<QuerySnapshot>> getNotes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Listen to changes in the "Notes" subcollection
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Notes")
        .snapshots();
  }

  // 🔹 Update a note
  Future<void> updateNotes(Map<String, dynamic> notesInfoMap, String id) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Update the note by ID
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Notes")
        .doc(id)
        .update(notesInfoMap);
  }

  // 🔹 Delete a note
  Future<void> deleteNotes(String id) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Delete note document from Firestore
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Notes")
        .doc(id)
        .delete();
  }

  // ---------------------------------------------------------------
  // 🔹 User Profile Management
  // ---------------------------------------------------------------

  // 🔹 Create a user profile document in Firestore
  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Save user data under: UserProfile/{userId}
      await FirebaseFirestore.instance
          .collection("UserProfile")
          .doc(userId)
          .set(userData);
      return true;
    } catch (e) {
      // If there is an error, return false
      return false;
    }
  }

  // 🔹 Get current user's profile details
  Future<Map<String, dynamic>?> getUserDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // If user is not logged in, return null
    if (userId == null) return null;

    // Fetch user document from Firestore
    final doc =
        await FirebaseFirestore.instance
            .collection("UserProfile")
            .doc(userId)
            .get();

    // If it exists, return data as map
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  // ------- DataBaseMethods additions -------

  /// 🔹 All tasks (for calendar markers)
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserTasksStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snap, _) => snap.data()!,
          toFirestore: (data, _) => data,
        )
        .snapshots();
  }

  /// 🔹 Tasks filtered by a single date
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasksByDate(
    String formattedDate,
  ) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("UserProfile")
        .doc(userId)
        .collection("Tasks")
        .where('Date', isEqualTo: formattedDate)
        .orderBy('Sortable Start Time')
        .snapshots();
  }
}

