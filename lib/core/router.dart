import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/phone_input_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/dashboard/notifications_screen.dart';
import '../features/ticket/ticket_retrieval_screen.dart';
import '../features/ticket/fare_screen.dart';
import '../features/payment/payment_screen.dart';
import '../features/pass/pass_screen.dart';
import '../features/emergency/emergency_screen.dart';
import '../features/vehicles/add_vehicle_screen.dart';
import '../features/attendant/attendant_login_screen.dart';
import '../features/attendant/attendant_dashboard_screen.dart';
import '../features/dashboard/main_shell.dart';
import '../features/wallet/wallet_screen.dart';
import '../features/vehicles/vehicle_list_screen.dart';
import '../features/trip/trip_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _payNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'pay');
final GlobalKey<NavigatorState> _tripNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'trip');
final GlobalKey<NavigatorState> _walletNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'wallet');
final GlobalKey<NavigatorState> _vehiclesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vehicles');
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
      path: '/attendant',
      builder: (context, state) => const AttendantLoginScreen(),
      routes: [
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => const AttendantDashboardScreen(),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home Branch
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
            GoRoute(
              path: '/pass',
              builder: (context, state) => PassScreen(
                isEmergency: state.extra as bool? ?? false,
              ),
            ),
            GoRoute(
              path: '/emergency',
              builder: (context, state) => const EmergencyScreen(),
            ),
          ],
        ),
        // Tab 1: Pay Ticket Branch
        StatefulShellBranch(
          navigatorKey: _payNavigatorKey,
          routes: [
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
          ],
        ),
        // Tab 2: Active Trip Branch
        StatefulShellBranch(
          navigatorKey: _tripNavigatorKey,
          routes: [
            GoRoute(
              path: '/trip',
              builder: (context, state) => const TripScreen(),
            ),
          ],
        ),
        // Tab 3: Wallet Branch
        StatefulShellBranch(
          navigatorKey: _walletNavigatorKey,
          routes: [
            GoRoute(
              path: '/wallet',
              builder: (context, state) => const WalletScreen(),
            ),
          ],
        ),
        // Tab 4: Vehicles Branch
        StatefulShellBranch(
          navigatorKey: _vehiclesNavigatorKey,
          routes: [
            GoRoute(
              path: '/vehicles',
              builder: (context, state) => const VehicleListScreen(),
            ),
            GoRoute(
              path: '/add_vehicle',
              builder: (context, state) => const AddVehicleScreen(),
            ),
          ],
        ),
        // Tab 5: Profile Branch
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
