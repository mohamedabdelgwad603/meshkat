import 'package:flutter/material.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/features/player/presentation/widgets/player_body.dart';

// Full-screen recitation player; uses the app-wide player cubit so audio keeps playing after closing.
class PlayerScreen extends StatelessWidget {
  final PlayerArgs? args;

  // Creates the player, optionally opening a surah at an ayah.
  const PlayerScreen({super.key, this.args});

  // Builds the body.
  @override
  Widget build(BuildContext context) => PlayerBody(args: args);
}
