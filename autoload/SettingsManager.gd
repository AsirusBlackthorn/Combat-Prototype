# DESIGN BRIEF - SettingsManager (Autoload Singleton)
#
# Purpose: Loads, stores, and applies graphics, audio, and
# gameplay settings. Persists to a config file.
#
# Responsibilities:
# - Graphics: resolution, fullscreen, vsync, quality presets
# - Audio: master/sfx/music/voice volume levels
# - Gameplay: sensitivity, invert Y, subtitles, etc.
# - Apply settings immediately when changed
# - Save/load from user://settings.cfg
#
# Methods needed:
# - apply_graphics_settings() -> void
# - apply_audio_settings() -> void
# - set_setting(key: String, value) -> void
# - get_setting(key: String, default = null)
# - save_settings() -> void
# - load_settings() -> void
# - reset_to_defaults() -> void
#
# Stores settings as a Dictionary internally.
# Default values are hardcoded or read from ProjectSettings.

extends Node

const SETTINGS_PATH := "user://settings.cfg"

var _settings: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS