import 'package:get/get.dart';
import 'package:quick_notes/Navbar/bottam_navbar.dart';
import 'package:quick_notes/Views/Password_rest/otp_page.dart';
import 'package:quick_notes/Views/Password_rest/password_reset_screen.dart';
import 'package:quick_notes/Views/Task/task_screen.dart';
import 'package:quick_notes/Views/calendar_page.dart';
import 'package:quick_notes/Views/home_page.dart';
import 'package:quick_notes/Views/login_page.dart';
import 'package:quick_notes/Views/onboard_details/user_onboard_details.dart';
import 'package:quick_notes/Views/profile_page.dart';
import 'package:quick_notes/Views/signup_page.dart';
import 'package:quick_notes/Views/splash_page.dart';
import 'package:quick_notes/Views/Task/task_create_page.dart';
import 'package:quick_notes/widgets/Home/notes_create_screen.dart';

class AppRoutes {
  static const String splashPage = '/';

  // static const String authWarpper = '/authWrapper';

  static const String loginPage = '/loginScreen';

  static const String signupPage = '/SignupScreen';

  static const String homePage = '/homeScreen';

  static const String calendarPage = '/calendarScreen';

  static const String passwordResetPage = '/passwordResetScreen';

  static const String profilePage = '/profileScreen';

  static const String customBottomNavBar = '/customBottomNavBar';

  static const String userOnBoardScreen = '/userOnBoardScreen';

  static const String otpScreen = '/otpScreen';

  static const String taskCreateScreen = '/taskCreateScreen';

  static const String taskMainScreen = '/taskMainScreen';

  static const String notesCreateScreen = '/notesCreateScreen';

  // static const String fullNotesScreen = '/fullNotesScreen';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    // GetPage(name: authWarpper, page: () => const AuthWrapper()),
    GetPage(name: loginPage, page: () => const LoginPage()),
    GetPage(name: signupPage, page: () => const SignupPage()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: calendarPage, page: () => const CalendarPage()),
    GetPage(name: passwordResetPage, page: () => const PasswordResetScreen()),
    GetPage(name: profilePage, page: () => const ProfilePage()),
    GetPage(name: customBottomNavBar, page: () => const BottomNavbar()),
    GetPage(name: userOnBoardScreen, page: () => const UserOnboardDetails()),
    GetPage(name: otpScreen, page: () => const OtpPage()),
    GetPage(name: taskCreateScreen, page: () => const TaskCreatePage()),
    GetPage(name: taskMainScreen, page: () => const TaskScreen()),
    GetPage(name: notesCreateScreen, page: () => NotesCreateScreen()),

    //  GetPage(name: fullNotesScreen, page: () => const FullNotesView()),
  ];
}
