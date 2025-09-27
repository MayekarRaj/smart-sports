import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final List<NotificationItem> notifications;
  final VoidCallback? onMarkAllRead;
  final Function(NotificationItem)? onNotificationTap;
  final Function(NotificationItem)? onNotificationDelete;

  const NotificationPage({
    super.key,
    required this.notifications,
    this.onMarkAllRead,
    this.onNotificationTap,
    this.onNotificationDelete,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0 && widget.onMarkAllRead != null)
            TextButton(
              onPressed: widget.onMarkAllRead,
              child: const Text('Mark All Read'),
            ),
        ],
      ),
      body: widget.notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: widget.notifications.length,
              itemBuilder: (context, index) {
                final notification = widget.notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        widget.onNotificationDelete?.call(notification);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? Colors.grey[300]
              : Theme.of(context).primaryColor,
          child: Icon(
            notification.icon,
            color: notification.isRead ? Colors.grey[600] : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          widget.onNotificationTap?.call(notification);
        },
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });
}

// Predefined notification types
class NotificationTypes {
  static NotificationItem booking({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: Icons.calendar_today,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  static NotificationItem payment({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: Icons.payment,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  static NotificationItem event({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: Icons.event,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  static NotificationItem system({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: Icons.info,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  static NotificationItem warning({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: Icons.warning,
      timestamp: timestamp,
      isRead: isRead,
    );
  }
}
