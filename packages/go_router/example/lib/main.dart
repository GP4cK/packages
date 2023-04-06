// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          onExit: (BuildContext context) async {
            print('onExit');
            return true;
          },
          builder: (BuildContext context, GoRouterState state) {
            return const DetailsScreen();
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.push('/details'),
              child: const Text(
                  'Push the Details screen (page based) & GoRouter.pop'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DetailsScreen(),
                ),
              ),
              child: const Text(
                  'Push the Details screen (pageless) & GoRouter.pop'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DetailsScreen(
                    useNavigatorToPop: true,
                  ),
                ),
              ),
              child: const Text(
                  'Push the Details screen (pageless) & Navigator.pop'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          child: Dialog(
                            child: Card(
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Pop'),
                                ),
                              ),
                            ),
                          ),
                          onWillPop: () async {
                            print('onWillPop');
                            return true;
                          });
                    });
              },
              child: const Text('showDialog & Navigator.pop'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({this.useNavigatorToPop = false, super.key});

  final bool useNavigatorToPop;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPop');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Details Screen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <ElevatedButton>[
              ElevatedButton(
                onPressed: () {
                  if (useNavigatorToPop) {
                    Navigator.of(context).pop();
                  } else {
                    GoRouter.of(context).pop();
                  }
                },
                child: const Text('Go back to the Home screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
