import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/phone_input_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/ticket/ticket_retrieval_screen.dart';
import '../features/ticket/fare_screen.dart';
import '../features/payment/payment_screen.dart';
import '../features/pass/pass_screen.dart';
import '../features/emergency/emergency_screen.dart';
import '../features/vehicles/add_vehicle_screen.dart';
import '../features/attendant/attendant_login_screen.dart';
import '../features/attendant/attendant_dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const PhoneInputScreen(),
      routes: [
        GoRoute(
          path: 'otp',
          builder: (context, state) => const OtpScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/ticket',
      builder: (context, state) => const TicketRetrievalScreen(),
    ),
    GoRoute(
      path: '/fare',
      builder: (context, state) => const FareScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/pass',
      builder: (context, state) => PassScreen(isEmergency: state.extra as bool? ?? false),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyScreen(),
    ),
    GoRoute(
      path: '/add_vehicle',
      builder: (context, state) => const AddVehicleScreen(),
    ),
    GoRoute(
      path: '/attendant',
      builder: (context, state) => const AttendantLoginScreen(),
      routes: [
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const AttendantDashboardScreen(),
        ),
      ],
    ),
  ],
);
