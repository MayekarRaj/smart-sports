import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? indicatorSize;

  const LoadingPage({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        backgroundColor ?? (isDark ? Colors.grey[900] : Colors.white);
    final indicatorColor = this.indicatorColor ?? theme.primaryColor;
    final size = indicatorSize ?? 40.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                strokeWidth: 3.0,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SkeletonLoadingPage extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? skeletonColor;

  const SkeletonLoadingPage({
    super.key,
    this.message,
    this.backgroundColor,
    this.skeletonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        backgroundColor ?? (isDark ? Colors.grey[900] : Colors.grey[50]);
    final skeletonColor =
        this.skeletonColor ?? (isDark ? Colors.grey[700] : Colors.grey[300]);

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) =>
                    _buildSkeletonItem(skeletonColor ?? Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonItem(Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: 150,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressLoadingPage extends StatefulWidget {
  final String? message;
  final double? progress;
  final Color? backgroundColor;
  final Color? progressColor;

  const ProgressLoadingPage({
    super.key,
    this.message,
    this.progress,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  State<ProgressLoadingPage> createState() => _ProgressLoadingPageState();
}

class _ProgressLoadingPageState extends State<ProgressLoadingPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor =
        widget.backgroundColor ?? (isDark ? Colors.grey[900] : Colors.white);
    final progressColor = widget.progressColor ?? theme.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.message != null) ...[
                Text(
                  widget.message!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: widget.progress,
                  backgroundColor: progressColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              if (widget.progress != null) ...[
                const SizedBox(height: 16),
                Text(
                  '${(widget.progress! * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
