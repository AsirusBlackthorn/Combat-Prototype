# res://CameraController.gd
# Edit file: res://CameraController.gd
extends Camera3D

@export var target: Node3D
@export var distance: float = 4.0
@export var rotation_speed: float = 3.0
@export var min_pitch: float = -80.0
@export var max_pitch: float = 89.0

var pitch: float = 0.0
var yaw: float = 0.0

func _ready():
	make_current()
	
	if not target:
		target = get_node("../Player")
	
	# Start behind the player at a slight downward angle
	pitch = deg_to_rad(-15.0)
	yaw = 0.0
	# Apply initial position so the camera doesn't start at origin
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
	
	var offset = rotation_basis * Vector3.BACK * distance
	global_position = target.global_position + offset
	
	look_at(target.global_position, Vector3.UP)
