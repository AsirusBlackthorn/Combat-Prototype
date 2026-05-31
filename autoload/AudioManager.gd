# DESIGN BRIEF - AudioManager (Autoload Singleton)
#
# Purpose: Centralized audio playback with sound pooling,
# bus management, and volume control.
#
# Responsibilities:
# - Play SFX via AudioStreamPlayer2D/3D pools (reuse players)
# - Play music with crossfade support
# - Respect volume sliders for SFX, Music, Master buses
# - Handle spatial audio for 3D sounds (attach to nodes)
#
# Methods needed:
# - play_sfx(sfx: AudioStream, position: Vector3 = null) -> void
# - play_music(music: AudioStream, fade_time: float = 1.0) -> void
# - stop_music(fade_time: float = 1.0) -> void
# - set_bus_volume(bus_name: String, volume_db: float) -> void
# - get_bus_volume(bus_name: String) -> float
#
# Uses Godot's AudioServer buses (Master, SFX, Music, Voice).
# Create these buses in Audio > Bus Layout before implementing.

extends Node

enum Bus { MASTER, SFX, MUSIC, VOICE }

var _music_player: AudioStreamPlayer = null
var _sfx_pool: Array[AudioStreamPlayer3D] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS