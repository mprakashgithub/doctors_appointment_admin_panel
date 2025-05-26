import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/layout/main_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Settings',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Settings
            _buildSection(
              title: 'Profile Settings',
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildTextField('Full Name', 'John Doe'),
                  const SizedBox(height: 16),
                  _buildTextField('Email', 'john.doe@example.com'),
                  const SizedBox(height: 16),
                  _buildTextField('Phone', '+1 234 567 8900'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Notification Settings
            _buildSection(
              title: 'Notification Settings',
              child: Column(
                children: [
                  _buildSwitchTile(
                    'Email Notifications',
                    'Receive notifications via email',
                    true,
                  ),
                  _buildSwitchTile(
                    'SMS Notifications',
                    'Receive notifications via SMS',
                    false,
                  ),
                  _buildSwitchTile(
                    'App Notifications',
                    'Receive notifications in the app',
                    true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Security Settings
            _buildSection(
              title: 'Security Settings',
              child: Column(
                children: [
                  _buildButton('Change Password', Icons.lock, () {}),
                  const SizedBox(height: 16),
                  _buildButton(
                    'Two-Factor Authentication',
                    Icons.security,
                    () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // System Settings
            _buildSection(
              title: 'System Settings',
              child: Column(
                children: [
                  _buildDropdown(
                      'Language',
                      [
                        'English',
                        'Spanish',
                        'French',
                        'German',
                      ],
                      'English'),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      'Time Zone',
                      [
                        'UTC',
                        'EST',
                        'PST',
                        'GMT',
                      ],
                      'UTC'),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      'Date Format',
                      [
                        'MM/DD/YYYY',
                        'DD/MM/YYYY',
                        'YYYY-MM-DD',
                      ],
                      'MM/DD/YYYY'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Danger Zone
            _buildSection(
              title: 'Danger Zone',
              child: Column(
                children: [
                  _buildDangerButton(
                    'Delete Account',
                    Icons.delete_forever,
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person,
            size: 40,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Administrator',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      value: value,
      onChanged: (bool value) {},
    );
  }

  Widget _buildButton(String title, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: (String? value) {},
    );
  }

  Widget _buildDangerButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
