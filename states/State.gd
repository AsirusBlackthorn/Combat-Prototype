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
