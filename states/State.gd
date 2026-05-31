# res://states/State.gd
class_name State
extends Node

# Reference to the character this state belongs to.
# Set by the StateMachine when the state is registered.
var character: Node = null

# Called when this state becomes the active state.
func enter() -> void:
	pass

# Called when this state is no longer the active state.
func exit() -> void:
	pass

# Called every frame while this state is active.
func update(delta: float) -> void:
	pass

# Called every physics frame while this state is active.
func physics_update(delta: float) -> void:
	pass
# Optional: override in sub-states for custom airborne behaviour
func air_update(_delta: float) -> void:
	# Default: do nothing (air control handled by manager or individual states)
	pass

# Returns true if the character has an air action left
func can_perform_air_action() -> bool:
	if not character:
		return false
	return character.air_actions_remaining > 0

# Consume one air action (returns false if none left)
func consume_air_action() -> bool:
	if not character or character.air_actions_remaining <= 0:
		return false
	character.air_actions_remaining -= 1
	return true
