import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_controller/landing.dart';
import 'package:smart_controller/main.dart';
import 'package:smart_controller/views/SplashScreen.dart';
import 'package:smart_controller/views/add_devices.dart';
import 'package:smart_controller/views/listMotorDevice.dart';
import 'package:smart_controller/views/select_device.dart';

final GoRouter router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'landing',
          builder: (BuildContext context, GoRouterState state) =>
              const LandingScreen(),
        ),
        GoRoute(
          path: 'selectDevice',
          builder: (BuildContext context, GoRouterState state) =>
              const SelectDevice(),
        ),
        GoRoute(
          path: 'addDevice',
          builder: (BuildContext context, GoRouterState state) =>
              const AddADevice(),
        ),
        GoRoute(
          path: 'chooseMotor',
          builder: (BuildContext context, GoRouterState state) =>
              const ChooseMotorScreen(),
        ),
      ],
    ),
  ],
);
