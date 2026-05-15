import 'package:quem_e_o_impostor/core/constants/pixel_png_assets.dart';

class PlayerAvatarService {
  static String avatarForPlayer(String nome) {
    final normalized = nome.trim().toLowerCase();
    final hash = _stableHash(normalized);
    final avatars = PixelPngAssets.playerAvatars;
    return avatars[hash % avatars.length];
  }

  static int _stableHash(String value) {
    var result = 0;
    for (final rune in value.runes) {
      result = (result * 31 + rune) & 0x7fffffff;
    }
    return result;
  }
}
