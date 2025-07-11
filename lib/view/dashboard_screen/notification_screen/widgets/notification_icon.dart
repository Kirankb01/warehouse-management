import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

import '../../../../constants/app_colors.dart';

class NotificationIcon extends StatefulWidget {
  final bool hasNotifications;
  const NotificationIcon({required this.hasNotifications, super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.hasNotifications ? _controller : const AlwaysStoppedAnimation(1.0),
      child: Icon(
        widget.hasNotifications ? Icons.notifications_active : Icons.notifications,
        color: widget.hasNotifications ? AppColors.alertColor : AppThemeHelper.iconColor(context),
        size: 28,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
