# res://LevelBoundary.gd

#Develop logic that handles collision shapes differently depending on their definition:
#Typical instances of LevelBoundary.tscn: keep current behaviour.
# 'See-through' level boundaries: collide with the player, but not the camera or camera arm.

@tool
extends Node3D

## Assign a BoundaryConfig resource to define all boundary pieces
@export var config: BoundaryConfig:
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
var _config: BoundaryConfig

func _ready():
	apply_config()

func apply_config():
	if not config:
		return

	for child in get_children():
		child.free()

	var count: int = min(config.meshes.size(), config.shapes.size())
	for i in range(count):
		var static_body := StaticBody3D.new()
		add_child(static_body)
		static_body.owner = self

		if config.positions and i < config.positions.size():
			static_body.position = config.positions[i]

		if config.rotations and i < config.rotations.size():
			static_body.rotation_degrees = config.rotations[i]

		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = config.meshes[i]
		static_body.add_child(mesh_instance)
		mesh_instance.owner = self

		var collision_shape := CollisionShape3D.new()
		collision_shape.shape = config.shapes[i]
		static_body.add_child(collision_shape)
		collision_shape.owner = self
