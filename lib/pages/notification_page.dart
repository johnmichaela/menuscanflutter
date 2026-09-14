import 'dart:convert';

import 'package:ballon/pages/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _selectedFilter = 'All';
  // List<NotificationData> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      // _notifications = NotificationService.getNotifications();
      // _unreadCount = NotificationService.getUnreadCount();
      // _isLoading = false;
    });
  }

  // ==================== FILTER NOTIFICATIONS ====================
  
  // List<NotificationData> get _filteredNotifications {
  //   if (_selectedFilter == 'All') {
  //     return _notifications;
  //   }
  //   if (_selectedFilter == 'Unread') {
  //     return _notifications.where((n) => !n.read).toList();
  //   }
  //   return _notifications;
  // }

  // // ==================== MARK AS READ ====================
  
  // Future<void> _markAsRead(String id) async {
  //   await NotificationService.markAsRead(id);
  //   _loadNotifications();
  // }

  // Future<void> _markAllAsRead() async {
  //   await NotificationService.markAllAsRead();
  //   _loadNotifications();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('All notifications marked as read'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  // }

  // // ==================== DELETE NOTIFICATION ====================
  
  // Future<void> _deleteNotification(String id) async {
  //   await NotificationService.deleteNotification(id);
  //   _loadNotifications();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Notification deleted'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  // }

  // Future<void> _clearAll() async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Clear All'),
  //         content: const Text('Are you sure you want to clear all notifications?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               await NotificationService.clearAll();
  //               _loadNotifications();
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('All notifications cleared'),
  //                   backgroundColor: Colors.green,
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //               foregroundColor: Colors.white,
  //             ),
  //             child: const Text('Clear All'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(time);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

// Send notification from your app
Future<void> sendTestNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('fcm_token');
  
  if (token != null) {
    final response = await http.post(
      Uri.parse('http://192.168.1.115:8000/api/send-notification/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': token,
        'title': 'Test Notification',
        'body': 'This is a test notification from Balloon app',
      }),
    );
    
    if (response.statusCode == 200) {
      print('✅ Notification sent');
    }
  }
}
  @override
  Widget build(BuildContext context) {
    // final filtered = _filteredNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                    color: Color(0xFFB71C1C),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            // TextButton(
            //   onPressed: _markAllAsRead,
            //   child: const Text(
            //     'Mark All Read',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 12,
            //     ),
            //   ),
            // ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NotificationSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Tabs
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'All'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Unread', 'Unread'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Orders', 'Orders'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Promotions', 'Promotions'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Restaurants', 'Restaurants'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Reviews', 'Reviews'),
                      ],
                    ),
                  ),
                ),

                // Notifications List
                // Expanded(
                //   child: filtered.isEmpty
                //       ? _buildEmptyState()
                //       : ListView.builder(
                //           padding: const EdgeInsets.all(8),
                //           itemCount: filtered.length,
                //           itemBuilder: (context, index) {
                //             final notification = filtered[index];
                //             return _buildNotificationCard(notification);
                //           },
                //         ),
                // ),
              ],
            ),
    );
  }

  // ==================== FILTER CHIP ====================
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB71C1C) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFB71C1C) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ==================== NOTIFICATION CARD ====================
  
  // Widget _buildNotificationCard(NotificationData notification) {
  //   return Dismissible(
  //     key: Key(notification.id),
  //     direction: DismissDirection.endToStart,
  //     background: Container(
  //       alignment: Alignment.centerRight,
  //       padding: const EdgeInsets.only(right: 20),
  //       color: Colors.red,
  //       child: const Icon(Icons.delete, color: Colors.white),
  //     ),
  //     onDismissed: (_) {
  //       _deleteNotification(notification.id);
  //     },
  //     child: GestureDetector(
  //       onTap: () {
  //         _markAsRead(notification.id);
  //       },
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: notification.read ? Colors.white : const Color(0xFFFFF5F5),
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 10,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //           border: Border.all(
  //             color: notification.read ? Colors.transparent : const Color(0xFFB71C1C).withOpacity(0.3),
  //             width: 1,
  //           ),
  //         ),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFB71C1C).withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: const Icon(
  //                 Icons.notifications,
  //                 color: Color(0xFFB71C1C),
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           notification.title,
  //                           style: TextStyle(
  //                             fontWeight: notification.read ? FontWeight.w500 : FontWeight.bold,
  //                             fontSize: 14,
  //                             color: notification.read ? Colors.grey.shade700 : const Color(0xFF333333),
  //                           ),
  //                         ),
  //                       ),
  //                       if (!notification.read)
  //                         Container(
  //                           width: 8,
  //                           height: 8,
  //                           decoration: const BoxDecoration(
  //                             color: Color(0xFFB71C1C),
  //                             shape: BoxShape.circle,
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     notification.body,
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey.shade600,
  //                       height: 1.3,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Row(
  //                     children: [
  //                       Text(
  //                         _getTimeAgo(notification.timestamp),
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           color: Colors.grey.shade400,
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       GestureDetector(
  //                         onTap: () => _deleteNotification(notification.id),
  //                         child: Icon(
  //                           Icons.close,
  //                           size: 16,
  //                           color: Colors.grey.shade400,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ==================== EMPTY STATE ====================
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'You have no notifications yet'
                : 'No ${_selectedFilter.toLowerCase()} notifications',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedFilter != 'All')
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                foregroundColor: Colors.white,
              ),
              child: const Text('View All Notifications'),
            ),
        ],
      ),
    );
  }
}