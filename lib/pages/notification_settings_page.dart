import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // ==================== SETTINGS STATE ====================
  
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _newRestaurants = true;
  bool _reviews = true;
  bool _events = false;
  bool _messages = true;
  
  bool _quietHours = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==================== NOTIFICATION TYPES ====================
            _buildSectionCard(
              title: 'Notification Channels',
              icon: Icons.notifications_active,
              children: [
                _buildSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'SMS Notifications',
                  subtitle: 'Receive notifications via SMS',
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // ==================== NOTIFICATION PREFERENCES ====================
            _buildSectionCard(
              title: 'Notification Preferences',
              icon: Icons.settings,
              children: [
                _buildSwitchTile(
                  title: 'Order Updates',
                  subtitle: 'Get notified about order status changes',
                  value: _orderUpdates,
                  onChanged: (value) {
                    setState(() {
                      _orderUpdates = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'Promotions & Offers',
                  subtitle: 'Receive special offers and promotions',
                  value: _promotions,
                  onChanged: (value) {
                    setState(() {
                      _promotions = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'New Restaurants',
                  subtitle: 'Get notified when new restaurants join',
                  value: _newRestaurants,
                  onChanged: (value) {
                    setState(() {
                      _newRestaurants = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'Reviews & Ratings',
                  subtitle: 'Notifications for new reviews on your profile',
                  value: _reviews,
                  onChanged: (value) {
                    setState(() {
                      _reviews = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'Events',
                  subtitle: 'Get notified about upcoming events',
                  value: _events,
                  onChanged: (value) {
                    setState(() {
                      _events = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchTile(
                  title: 'Messages',
                  subtitle: 'Get notified when you receive messages',
                  value: _messages,
                  onChanged: (value) {
                    setState(() {
                      _messages = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // ==================== QUIET HOURS ====================
            _buildSectionCard(
              title: 'Quiet Hours',
              icon: Icons.bedtime,
              children: [
                _buildSwitchTile(
                  title: 'Enable Quiet Hours',
                  subtitle: 'Mute notifications during specified hours',
                  value: _quietHours,
                  onChanged: (value) {
                    setState(() {
                      _quietHours = value;
                    });
                  },
                ),
                if (_quietHours) ...[
                  _buildDivider(),
                  _buildTimePickerRow(
                    title: 'Start Time',
                    time: _quietStart,
                    onTap: () => _selectTime(true),
                  ),
                  _buildDivider(),
                  _buildTimePickerRow(
                    title: 'End Time',
                    time: _quietEnd,
                    onTap: () => _selectTime(false),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 24),
            
            // ==================== SAVE BUTTON ====================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION CARD ====================
  
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFB71C1C), size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  // ==================== SWITCH TILE ====================
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFB71C1C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
    );
  }

  // ==================== TIME PICKER ROW ====================
  
  Widget _buildTimePickerRow({
    required String title,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time.format(context),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFFB71C1C),
            ),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // ==================== DIVIDER ====================
  
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // ==================== SELECT TIME ====================
  
  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietStart : _quietEnd,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB71C1C),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietStart = picked;
        } else {
          _quietEnd = picked;
        }
      });
    }
  }

  // ==================== SAVE SETTINGS ====================
  
  void _saveSettings() {
    // Here you would save settings to SharedPreferences or API
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Close the page after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    });
  }
}