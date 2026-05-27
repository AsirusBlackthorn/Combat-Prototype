# res://Player.gd

#Development Specification:
#Supersede current movement logic using the 'MovementState' structure within StateMachine.tscn.
#I expect that what will remain will include input methods and camera-relative rules for MovementStates

@tool
extends Character

func _handle_movement(delta: float) -> void:
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction from actions
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	# Camera-relative movement
	var camera = get_viewport().get_camera_3d()
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	# Flatten to XZ plane and normalize
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	var direction = forward * input_dir.y + right * input_dir.x

	if direction.length() > 0.1:
		direction = direction.normalized()
		# Smoothly rotate player to face movement direction
		var target_basis = Basis().looking_at(direction, Vector3.UP)
		basis = basis.slerp(target_basis, rotation_speed * delta)
		# Apply movement
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Decelerate
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)
