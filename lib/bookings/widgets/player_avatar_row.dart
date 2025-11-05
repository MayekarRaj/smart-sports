import 'package:flutter/material.dart';

class PlayerAvatarRow extends StatelessWidget {
  final List<dynamic> players;
  final int maxVisible;
  final double avatarSize;

  const PlayerAvatarRow({
    Key? key,
    required this.players,
    this.maxVisible = 4,
    this.avatarSize = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return const SizedBox.shrink();
    }

    final visiblePlayers = players.take(maxVisible).toList();
    final remainingCount = players.length - maxVisible;

    return Row(
      children: [
        ...visiblePlayers.map((player) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundImage: NetworkImage(player.imageUrl),
              backgroundColor: Colors.grey.shade300,
              child: player.imageUrl.isEmpty
                  ? Icon(
                      Icons.person,
                      size: avatarSize * 0.6,
                      color: Colors.grey.shade600,
                    )
                  : null,
            ),
          );
        }).toList(),
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: 4),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.grey.shade400,
              child: Text(
                '+$remainingCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: avatarSize * 0.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
