# res://LevelBoundary.gd
@tool
extends Node3D

## Assign a BoundaryConfig resource to define all boundary pieces
@export var config: BoundaryConfig:
	set(value):
		_config = value
		if Engine.is_editor_hint():
			apply_config()
	get:
		return _config
var _config: BoundaryConfig

func _ready():
	apply_config()

func apply_config():
	if not config:
		return

	# Clear existing children first (for editor re-apply)
	for child in get_children():
		child.queue_free()

	# Create mesh + collision pairs from config
	var count: int = min(config.meshes.size(), config.shapes.size())
	for i in range(count):
		# StaticBody3D is the physics parent — makes collision work
		var static_body := StaticBody3D.new()
		add_child(static_body)
		static_body.owner = self
		
		# Apply transform if provided
		if config.transforms and i < config.transforms.size():
			static_body.transform = config.transforms[i]
		
		# Visual mesh
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = config.meshes[i]
		static_body.add_child(mesh_instance)
		mesh_instance.owner = self
		
		# Collision shape (must be child of StaticBody3D to work)
		var collision_shape := CollisionShape3D.new()
		collision_shape.shape = config.shapes[i]
		static_body.add_child(collision_shape)
		collision_shape.owner = self
