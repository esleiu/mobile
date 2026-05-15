import 'package:flutter/material.dart';
import 'package:quem_e_o_impostor/core/services/servico_avatar_jogador.dart';
import 'package:quem_e_o_impostor/shared/widgets/bolha_sprite_arcade.dart';

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
