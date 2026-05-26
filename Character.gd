#Character.gd design specification:

#Manage logic and data that is shared by all characters in game
#Including the application of physics processes, and StateMachine.tscn
#Consider whether StateMachine.tscn needs to be added as a child of the CharacterBase.tscn root node?

extends CharacterBody3D

#Define as base class

@export var config: CharacterConfig

@onready var mesh_instance: MeshInstance3D = $Mesh
@onready var collision_shape: CollisionShape3D = $Collision
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

func _ready():
	apply_config()

func apply_config():
	if not config:
		return
	
	# Apply mesh
	mesh_instance.mesh = config.mesh
	if config.material_override:
		mesh_instance.material_override = config.material_override
	
	# Apply collision
	collision_shape.shape = config.collision_shape
	collision_layer = config.collision_layer
	collision_mask = config.collision_mask
	
	# Apply animations
	if config.animation_library:
		anim_player.add_animation_library("", config.animation_library)
	if config.animation_tree:
		anim_tree.tree_root = config.animation_tree
	
	# Apply stats (shared with controller)
	for child in get_children():
		if child.has_method("set_stats"):
			child.set_stats(config.stats)
