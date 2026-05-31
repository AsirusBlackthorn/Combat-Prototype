# res://states/Movement/JumpState.gd
# JumpState: applies vertical + lateral impulse on enter, then immediately
# transitions to the appropriate airborne state (MoveState or IdleState).
extends "res://states/State.gd"

# JumpState is a burst state: it applies the jump impulse on enter and
# then immediately exits. Air control and landing detection are handled
# by the MovementStateMachine.

func enter() -> void:
	if not character:
		return

	var on_floor: bool = character.is_on_floor()

	# --- Determine if this is a double-jump ---
	if not on_floor:
		# Double-jump: consume an air action if available
		if not can_perform_air_action():
			# No air actions left – exit to the appropriate air state without applying impulse
			_exit_to_air_state()
			return
		consume_air_action()

	# --- Apply vertical impulse ---
	character.velocity.y = character.jump_velocity

	# --- Apply lateral impulse if movement input exists ---
	var direction: Vector3 = character.move_direction
	if direction.length() > 0.1:
		direction = direction.normalized()
		var horizontal_speed: float = character.speed * 0.7
		character.velocity.x = direction.x * horizontal_speed
		character.velocity.z = direction.z * horizontal_speed
		# Flatten to horizontal plane for rotation
		var flat_direction := Vector3(direction.x, 0.0, direction.z).normalized()
		# Rotate character to face jump direction (snap)
		var target_basis := Basis().looking_at(flat_direction, Vector3.UP)
	else:
		# No input: preserve existing horizontal velocity (momentum)
		pass

	# --- Immediately transition to the appropriate air state ---
	_exit_to_air_state()

func _exit_to_air_state() -> void:
	if not character:
		return

	var movement_sm = character.state_machine.get_node_or_null("MovementStates")
	if not movement_sm:
		return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() > 0.1:
		movement_sm.transition_to("MoveState")
	else:
		movement_sm.transition_to("IdleState")
