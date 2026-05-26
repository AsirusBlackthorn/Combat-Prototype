# res://CameraController.gd
# Edit file: res://CameraController.gd
extends Camera3D

@export var target: Node3D
@export var distance: float = 4.0
@export var rotation_speed: float = 3.0
@export var min_pitch: float = -89.0
@export var max_pitch: float = 89.0
@export var collision_mask: int = 1
@export var collision_smooth_speed: float = 8.0

var pitch: float = 0.0
var yaw: float = 0.0
var _current_distance: float = 0.0

func _ready():
	make_current()
	_current_distance = distance

	if not target:
		target = get_node_or_null("../Player")
		if not target:
			target = get_node_or_null("../../Player")
		if not target:
			target = get_node_or_null("../../Character/Player")
	# Start behind the player at a slight downward angle
	pitch = deg_to_rad(-15.0)
	yaw = 0.0
	# Apply initial position so the camera doesn't start at origin
	if target:
		_update_camera()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * 0.003
		pitch -= event.relative.y * 0.003
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

func _process(delta):
	if not target:
		return

	var stick_x = Input.get_axis("camera_right", "camera_left")
	var stick_y = Input.get_axis("camera_down", "camera_up")

	yaw += stick_x * rotation_speed * delta
	pitch += stick_y * rotation_speed * delta
	pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

	_update_camera()

func _update_camera():
	if not target:
		return

	var rotation_basis = Basis()
	rotation_basis = rotation_basis.rotated(Vector3.UP, yaw)
	rotation_basis = rotation_basis.rotated(rotation_basis.x, pitch)

	# Ideal camera position (no collision)
	var ideal_offset = rotation_basis * Vector3.BACK * distance
	var ideal_position = target.global_position + ideal_offset

	# Raycast from target to ideal camera position
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		target.global_position,
		ideal_position,
		collision_mask
	)
	# Exclude the player from collision
	if target is CollisionObject3D:
		query.exclude = [target.get_rid()]

	var result = space_state.intersect_ray(query)

	if result:
		# Hit something — calculate how far we can go
		var hit_distance = target.global_position.distance_to(result.position)
		# Leave a small margin so camera isn't flush against the wall
		_current_distance = lerp(_current_distance, hit_distance - 0.2, collision_smooth_speed * get_process_delta_time())
	else:
		# No hit — smoothly return to full distance
		_current_distance = lerp(_current_distance, distance, collision_smooth_speed * get_process_delta_time())

	# Apply the smoothed distance
	var offset = rotation_basis * Vector3.BACK * _current_distance
	global_position = target.global_position + offset

	look_at(target.global_position, Vector3.UP)
