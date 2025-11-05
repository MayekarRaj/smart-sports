import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachTile extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final double size;

  const CoachTile({
    Key? key,
    required this.name,
    required this.email,
    required this.imageUrl,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.grey.shade300,
          child: imageUrl.isEmpty
              ? Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: Colors.grey.shade600,
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
