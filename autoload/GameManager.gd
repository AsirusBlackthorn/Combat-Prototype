# DESIGN BRIEF - GameManager (Autoload Singleton)
#
# Purpose: Central hub for global game state.
# Owns references to persistent data: player stats, inventory,
# current level name, game mode, difficulty, etc.
#
# Responsibilities:
# - Store references to player character (when spawned)
# - Track game-wide state (paused, transitioning, etc.)
# - Coordinate between SaveManager, SceneLoader, EventBus
# - Handle new game setup / continue logic
#
# This node is autoloaded via Project Settings > Autoload.
# It exists before any scene is loaded and persists forever.
#
# Fields needed:
# - current_player: Character (weak ref)
# - game_state: enum { MENU, LOADING, PLAYING, PAUSED, CUTSCENE }
# - new_game() / load_game() / save_game() delegates

extends Node

enum GameState { MENU, LOADING, PLAYING, PAUSED, CUTSCENE }

var current_game_state: GameState = GameState.MENU
var current_player: Character = null
var current_level_path: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS