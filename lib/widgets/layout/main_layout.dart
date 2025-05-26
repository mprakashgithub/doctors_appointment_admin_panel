import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../constants/theme.dart';
import 'sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const MainLayout({Key? key, required this.child, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar for Desktop
          if (isDesktop) const Sidebar(),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // App Bar
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Menu Button for Mobile/Tablet
                      if (!isDesktop)
                        Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Profile Section
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          if (ResponsiveBreakpoints.of(
                            context,
                          ).largerThan(MOBILE))
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admin User',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Administrator',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    color: AppTheme.backgroundColor,
                    padding: EdgeInsets.all(
                      ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                          ? 20
                          : 16,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer for Mobile/Tablet
      drawer: !isDesktop ? const Drawer(child: Sidebar()) : null,
    );
  }
}
