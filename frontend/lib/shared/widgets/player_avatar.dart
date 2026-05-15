import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/services/player_avatar_service.dart';
import 'package:quem_e_o_impostor/shared/widgets/arcade_sprite_bubble.dart';

class PlayerAvatar extends StatelessWidget {
  final String playerName;
  final double size;

  const PlayerAvatar({super.key, required this.playerName, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return ArcadeSpriteBubble(
      assetPath: PlayerAvatarService.avatarForPlayer(playerName),
      size: size,
    );
  }
}
