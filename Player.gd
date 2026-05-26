#Edit to inherit logic from base class "character.gd"
extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 10.0
@export var rotation_speed: float = 10.0
@export var jump_velocity: float = 4.5
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction from actions
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Camera-relative movement
	var camera = get_viewport().get_camera_3d()
	var forward = +camera.global_basis.z
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

	move_and_slide()
