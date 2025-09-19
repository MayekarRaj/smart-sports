import 'package:flutter/material.dart';

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});
  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, String t) => Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(i),
        label: Text(t),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      ),
    );
    return Row(
      children: [
        btn(Icons.g_mobiledata, 'Google'),
        const SizedBox(width: 12),
        btn(Icons.apple, 'Apple'),
        const SizedBox(width: 12),
        btn(Icons.facebook, 'Facebook'),
      ],
    );
  }
}
