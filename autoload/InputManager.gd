# DESIGN BRIEF - InputManager (Autoload Singleton)
#
# Purpose: Handles rebindable controls and persists custom
# key mappings to a config file.
#
# Responsibilities:
# - Store custom key bindings per action
# - Apply bindings to InputMap at startup
# - Provide UI-friendly action names and key display strings
# - Save/load bindings from user://input_settings.cfg
#
# Methods needed:
# - rebind_action(action: String, event: InputEvent, index: int = 0) -> void
# - reset_to_defaults() -> void
# - get_action_key_name(action: String, index: int = 0) -> String
# - save_bindings() -> void
# - load_bindings() -> void
#
# Works alongside the Settings menu UI.
# Default bindings come from Project > Input Map.

extends Node

const SETTINGS_PATH := "user://input_settings.cfg"

var _custom_bindings: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS