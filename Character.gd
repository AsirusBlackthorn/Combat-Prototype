# res://Character.gd
#Develop logic to implement resources for:
#Stats
#Equipment
#Skeleton rigs (with dynamic arrays for multiple limbs, and collisionshapes associated with each bone)
#Animations (Tree and player)

#Develop universal StateMachine.tscn logic
#Develop PushState logic in CollisionStates so the player can start interacting with the enemybase instance in DemoLevel.tscn

#Develop logic that handles camera collision with characters: 
#Avoid collision by extending camera arm away from player if possible
#If camera is caught between a non see-through LevelBoundary and a character, colliding character turns invisible and camera passes through

@tool
extends CharacterBody3D
class_name Character

@export var speed: float = 5.0
@export var acceleration: float = 10.0
@export var rotation_speed: float = 10.0
@export var jump_velocity: float = 4.5
@export var max_air_actions: int = 2
var air_actions_remaining: int = 2
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# Direction the character wants to move in (set each frame by Player/Enemy/Friend)
var move_direction: Vector3 = Vector3.ZERO

@onready var state_machine: Node = $CharacterBase/StateMachine

func _physics_process(delta: float) -> void:
	# Don't process physics in the editor (prevents falling in editor viewport)
	if Engine.is_editor_hint():
		return
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Let the state machine handle movement logic
	if state_machine:
		state_machine.physics_update(delta)

	# Always call move_and_slide() last
	move_and_slide()
# Called by SprintState when turning too sharply (overridden in Player.gd)
func stop_sprint() -> void:
	pass

# Virtual method – override in derived classes for custom movement
func _handle_movement(_delta: float) -> void:
	pass
@export var config: CharacterModelConfig:
	set(value):
		if _config:
			_config.changed.disconnect(apply_config)
		_config = value
		if _config:
			_config.changed.connect(apply_config)
		if Engine.is_editor_hint():
			apply_config()
	get:
		return _config
var _config: CharacterModelConfig

func _ready():
	apply_config()
	air_actions_remaining = max_air_actions

func apply_config():
	if not config:
		return

	# Remove old dynamically-added children (keep original scene children like AnimationTree, StateMachine etc.)
	for child in get_children():
		if child is MeshInstance3D or child is CollisionShape3D:
			child.free()

	var count: int = min(config.meshes.size(), config.shapes.size())
	for i in range(count):
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = config.meshes[i]
		add_child(mesh_instance)
		mesh_instance.owner = self
		if config.positions and i < config.positions.size():
			mesh_instance.position = config.positions[i]
		if config.rotations and i < config.rotations.size():
			mesh_instance.rotation_degrees = config.rotations[i]

		var collision_shape := CollisionShape3D.new()
		collision_shape.shape = config.shapes[i]
		add_child(collision_shape)
		collision_shape.owner = self
		if config.positions and i < config.positions.size():
			collision_shape.position = config.positions[i]
		if config.rotations and i < config.rotations.size():
			collision_shape.rotation_degrees = config.rotations[i]
