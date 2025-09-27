import 'package:flutter/material.dart';

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});
  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, String label, Color iconColor) => Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Handle social login
            },
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    return Row(
      children: [
        btn(Icons.g_mobiledata, 'Google', Colors.red.shade500),
        const SizedBox(width: 12),
        btn(Icons.apple, 'Apple', Colors.black87),
        const SizedBox(width: 12),
        btn(Icons.facebook, 'Facebook', Colors.blue.shade600),
      ],
    );
  }
}
