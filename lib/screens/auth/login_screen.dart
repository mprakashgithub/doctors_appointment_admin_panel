import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../constants/theme.dart';
import '../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: ResponsiveRowColumn(
            layout: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowSpacing: 32,
            columnSpacing: 32,
            children: [
              // Left side - Welcome Message
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: ResponsiveVisibility(
                  visible: ResponsiveBreakpoints.of(context).largerThan(TABLET),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Doctors Admin Panel',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Manage your medical practice efficiently with our comprehensive admin panel.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Right side - Login Form
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        ResponsiveBreakpoints.of(context).largerThan(TABLET)
                            ? 400
                            : double.infinity,
                  ),
                  padding: EdgeInsets.all(
                    ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                        ? 32
                        : 24,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo or App Name
                          const Text(
                            'Doctors Admin',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to your account',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 32),
                          // Email Field
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password Field
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Get.offAllNamed(Routes.dashboard),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Forgot Password
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
