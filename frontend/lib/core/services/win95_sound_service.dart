import 'package:audioplayers/audioplayers.dart';
import 'package:quem_e_o_impostor/core/constants/win95_sound_assets.dart';

class Win95SoundService {
  Win95SoundService._();

  static final Win95SoundService instance = Win95SoundService._();

  final AudioPlayer _startupPlayer = AudioPlayer(playerId: 'win95_startup');
  AudioPool? _clickPool;
  AudioPool? _alertPool;
  bool _initialized = false;
  final AudioContext _audioContext = AudioContextConfig(
    route: AudioContextConfigRoute.speaker,
    focus: AudioContextConfigFocus.gain,
    respectSilence: false,
    stayAwake: false,
  ).build();

  Future<void> _init() async {
    if (_initialized) return;
    await AudioPlayer.global.setAudioContext(_audioContext);
    await _startupPlayer.setAudioContext(_audioContext);
    await _startupPlayer.setSource(AssetSource(Win95SoundAssets.startup));
    await _startupPlayer.setReleaseMode(ReleaseMode.release);
    await _startupPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await _startupPlayer.setVolume(1.0);

    _clickPool ??= await AudioPool.create(
      source: AssetSource(Win95SoundAssets.click),
      maxPlayers: 3,
      minPlayers: 2,
      audioContext: _audioContext,
      playerMode: PlayerMode.mediaPlayer,
    );
    _alertPool ??= await AudioPool.create(
      source: AssetSource(Win95SoundAssets.alert),
      maxPlayers: 2,
      minPlayers: 1,
      audioContext: _audioContext,
      playerMode: PlayerMode.mediaPlayer,
    );

    _initialized = true;
  }

  Future<void> prime() async {
    await _init();
  }

  Future<void> playStartup() async {
    try {
      await _init();
      await _startupPlayer.stop();
      await _startupPlayer.resume();
    } catch (error) {
      // ignore: avoid_print
      print('Win95SoundService erro ao tocar startup: $error');
    }
  }

  Future<void> playClick() async {
    try {
      await _init();
      await _clickPool?.start(volume: 1.0);
    } catch (error) {
      // ignore: avoid_print
      print('Win95SoundService erro ao tocar click: $error');
    }
  }

  Future<void> playAlert() async {
    try {
      await _init();
      await _alertPool?.start(volume: 1.0);
    } catch (error) {
      // ignore: avoid_print
      print('Win95SoundService erro ao tocar alert: $error');
    }
  }

  Future<void> debugTestAll() async {
    await _init();
    await playClick();
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await playAlert();
    await Future<void>.delayed(const Duration(milliseconds: 450));
    await playStartup();
  }
}
