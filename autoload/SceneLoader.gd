# DESIGN BRIEF - SceneLoader (Autoload Singleton)
#
# Purpose: Handles additive scene loading/unloading with
# proper transitions (loading screen, fade, etc.).
#
# The persistent scene (e.g., "Gameplay") contains the player
# and camera. Levels are loaded additively as children of a
# "LevelContainer" node, then unloaded when leaving.
#
# Methods needed:
# - load_level(level_path: String) -> void
# - unload_current_level() -> void
# - restart_level() -> void
# - Signals: level_loaded, level_unloaded, load_progress_changed
#
# Use ResourceLoader.load_threaded_request() for async loading
# with progress tracking, and a loading screen UI.

extends Node

signal level_loaded(level_path: String)
signal level_unloaded
signal load_progress_changed(progress: float)

var _current_level: Node = null
var _level_container: Node = null