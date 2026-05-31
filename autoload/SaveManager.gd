# DESIGN BRIEF - SaveManager (Autoload Singleton)
#
# Purpose: Serializes and deserializes game state to/from disk.
# Uses Godot's ResourceSaver / ResourceLoader or ConfigFile.
#
# Save data includes:
# - Player stats, equipment, position, current level
# - World state (enemies defeated, doors opened, items collected)
# - Game settings (graphics, audio, controls)
#
# Methods needed:
# - save_game(slot: int) -> bool
# - load_game(slot: int) -> bool
# - get_save_metadata(slot: int) -> Dictionary
# - delete_save(slot: int)
# - get_save_list() -> Array[Dictionary]
#
# SaveManager reads/writes GameManager's state and serializes it.
# It does NOT hold game state itself — it's just the I/O layer.

extends Node

const SAVE_DIR := "user://saves/"
const SAVE_EXT := ".save"

func _ready() -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)