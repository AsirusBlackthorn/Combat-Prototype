# res://states/Movement/SprintState.gd
extends "res://states/State.gd"

@export var sprint_speed_multiplier: float = 2.0
@export var sprint_acceleration: float = 15.0
@export var min_turning_angle: float = 45.0  # degrees — if turn exceeds this, interrupt sprint

func enter() -> void:
	# Optional: play sprint animation / set sprint flags here
	pass

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	if not character:
		return

	var direction: Vector3 = character.move_direction

	if direction.length() > 0.1:
		direction = direction.normalized()

		# Check turning angle against current facing
		var current_facing: Vector3 = -character.global_basis.z
		var angle := rad_to_deg(current_facing.angle_to(direction))
		if angle > min_turning_angle:
			# Too sharp — interrupt sprint
			character.stop_sprint()
			var movement_sm = character.state_machine.get_node_or_null("MovementStates")
			if movement_sm:
				movement_sm.transition_to("MoveState")
			return

		var target_velocity = direction * (character.speed * sprint_speed_multiplier)
		character.velocity.x = move_toward(character.velocity.x, target_velocity.x, sprint_acceleration * delta)
		character.velocity.z = move_toward(character.velocity.z, target_velocity.z, sprint_acceleration * delta)
		# Rotate to face movement direction
		var target_basis := Basis().looking_at(direction, Vector3.UP)
		character.basis = character.basis.slerp(target_basis, character.rotation_speed * delta)
	else:
		# No input: decelerate
		character.velocity.x = move_toward(character.velocity.x, 0.0, sprint_acceleration * delta)
		character.velocity.z = move_toward(character.velocity.z, 0.0, sprint_acceleration * delta)

# Notes:
# - This state expects Player.gd to transition into/out of SprintState based on the shared ui_cancel input (hold to sprint / tap to dodge).
# - Future: add camera drift and recovery-frame handling on exit.
