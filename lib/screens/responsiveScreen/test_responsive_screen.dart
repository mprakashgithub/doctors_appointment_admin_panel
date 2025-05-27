import 'package:doctors_admin_panel/widgets/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestResponsiveScreen extends GetResponsiveView {
  TestResponsiveScreen({
    super.key,
  });

  ResponsiveMobileScreen mobile = const ResponsiveMobileScreen();

  @override
  Widget? phone() {
    return mobile;
  }

  @override
  Widget? tablet() {
    return const ResponsiveTabletScreen();
  }

  @override
  Widget? desktop() {
    return const ResponsiveDestopScreen();
  }
}

final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

class ResponsiveMobileScreen extends StatelessWidget {
  const ResponsiveMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Responsive mobile",
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            children: items.map((item) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ResponsiveTabletScreen extends StatelessWidget {
  const ResponsiveTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Responsive Tablet",
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 3, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            children: items.map((item) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ResponsiveDestopScreen extends StatelessWidget {
  const ResponsiveDestopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Responsive Desktop",
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 4, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            children: items.map((item) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
