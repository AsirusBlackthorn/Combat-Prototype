# res://states/Movement/IdleState.gd
extends "res://states/State.gd"
func enter() -> void:
		# Immediately stop horizontal movement when entering idle
		if character:
			character.velocity.x = 0.0
			character.velocity.z = 0.0

func air_update(delta: float) -> void:
	if not character:
		return
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * 0.03 * delta)
	character.velocity.z = move_toward(character.velocity.z, 0.0, character.acceleration * 0.03 * delta)
func physics_update(delta: float) -> void:
	if not character:
		return

	# Decelerate to a complete stop (keeps player stopped if pushed)
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * delta)
	character.velocity.z = move_toward(character.velocity.z, 0.0, character.acceleration * delta)
