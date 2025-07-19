import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Account Section
          settingsSectionTitle('Account'),
          settingsTile(
            context,
            title: 'Edit Profile',
            icon: Icons.person,
            onTap: () {
              // Navigate to Edit Profile Page
            },
          ),
          settingsTile(
            context,
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () {
              // Navigate to Change Password Page
            },
          ),
          const Divider(),

          // Notifications Section
          settingsSectionTitle('Notifications'),
          settingsToggleTile(
            title: 'Email Notifications',
            icon: Icons.email,
            isActive: true,
            onChanged: (value) {
              // Handle toggle
            },
          ),
          settingsToggleTile(
            title: 'Push Notifications',
            icon: Icons.notifications,
            isActive: false,
            onChanged: (value) {
              // Handle toggle
            },
          ),
          const Divider(),

          // Appearance Section
          settingsSectionTitle('Appearance'),
          settingsTile(
            context,
            title: 'Theme',
            icon: Icons.color_lens,
            onTap: () {
              // Navigate to Theme Selection Page
            },
          ),
          const Divider(),

          // Privacy Section
          settingsSectionTitle('Privacy'),
          settingsTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            onTap: () {
              // Navigate to Privacy Policy Page
            },
          ),
          settingsTile(
            context,
            title: 'Manage Permissions',
            icon: Icons.manage_accounts,
            onTap: () {
              // Navigate to Manage Permissions Page
            },
          ),
          const Divider(),

          // Support Section
          settingsSectionTitle('Support'),
          settingsTile(
            context,
            title: 'Help Center',
            icon: Icons.help_outline,
            onTap: () {
              // Navigate to Help Center Page
            },
          ),
          settingsTile(
            context,
            title: 'Contact Us',
            icon: Icons.contact_mail,
            onTap: () {
              // Navigate to Contact Us Page
            },
          ),
          const Divider(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle Logout
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget settingsTile(BuildContext context,
      {required String title,
        required IconData icon,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget settingsToggleTile({
    required String title,
    required IconData icon,
    required bool isActive,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      activeColor: Colors.indigo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      value: isActive,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      secondary: Icon(icon, color: Colors.indigo),
    );
  }
}
