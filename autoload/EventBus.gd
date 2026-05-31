# DESIGN BRIEF - EventBus (Autoload Singleton)
#
# Purpose: Decoupled communication between systems.
# Any script can emit signals on the EventBus without knowing
# who's listening. Any script can connect to EventBus signals
# without knowing who emits them.
#
# Examples:
# - Player took damage -> EventBus.player_damaged.emit(amount)
# - Enemy died -> EventBus.enemy_killed.emit(enemy)
# - Level loaded -> EventBus.level_loaded.emit(level_name)
# - Item picked up -> EventBus.item_collected.emit(item_id)
#
# This prevents spaghetti dependencies between state machines,
# UI, audio, save system, etc.
#
# Add signals here as needed during development.

extends Node

signal player_damaged(amount: float, source: Node3D)
signal player_healed(amount: float)
signal player_died
signal enemy_killed(enemy: Node3D)
signal item_collected(item_id: String)
signal level_loaded(level_name: String)
signal game_paused
signal game_unpaused