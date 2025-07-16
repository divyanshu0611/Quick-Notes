import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/Controller/Auth_controller/firebase_auth_controller.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final DataBaseMethods _db = DataBaseMethods();

  // ✅ Your database helper
  FirebaseAuthController firebaseAuthController = FirebaseAuthController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// 🔄 Fetch user data using your reusable method
  Future<void> fetchUserData() async {
    try {
      final data = await _db.getUserDetails(); // ✅ using your helper method
      if (mounted) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error fetching user data: $e");
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,

        leading: IconButton(
          onPressed:
              () => Get.offAllNamed(
                AppRoutes.customBottomNavBar,
                arguments: {'tabIndex': 0},
              ),
          icon: const Icon(Icons.arrow_back, size: 28),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              firebaseAuthController.logout();
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(child: Text("User data not found"))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        // 🔹 Profile Image (optional, fallback to asset)
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              userData!['profileImageUrl'] != null
                                  ? NetworkImage(userData!['profileImageUrl'])
                                  : const AssetImage(
                                        "assets/icons/Rectangle 869.png",
                                      )
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 12),

                        // 🔹 Name & Role
                        Text(
                          "${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(userData?['position'] ?? ''),
                        const SizedBox(height: 10),

                        // 🔹 Edit Button (functionality can be added later)
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Edit Profile"),
                        ),
                        const SizedBox(height: 15),

                        // 🔽 Email Info
                        builProfileInfo(
                          icon: Icons.email_outlined,
                          iconColor: Colors.pink,
                          title: 'Email',
                          subtitle:
                              FirebaseAuth.instance.currentUser?.email ?? '',
                        ),
                        const SizedBox(height: 15),

                        // 🔽 Phone Info
                        builProfileInfo(
                          icon: Icons.phone_outlined,
                          iconColor: Colors.orange,
                          title: 'Phone',
                          subtitle: userData?['phone'] ?? 'Not Provided',
                        ),
                        const SizedBox(height: 15),

                        // 🔽 Location Info
                        builProfileInfo(
                          icon: Icons.cake_outlined,
                          iconColor: Colors.amber,
                          title: 'DOB',
                          subtitle: userData?['dob'] ?? '',
                        ),
                        const SizedBox(height: 15),

                        // // 🔽 Local Time Info
                        // builProfileInfo(
                        //   icon: Icons.alarm_on,
                        //   iconColor: Colors.greenAccent,
                        //   title: 'Local Time',
                        //   subtitle: TimeOfDay.now().format(context),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  /// 🔁 Reusable info tile
  Widget builProfileInfo({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,

      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(77, 205, 204, 204),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(title), Text(subtitle)],
          ),
        ],
      ),
    );
  }
}
