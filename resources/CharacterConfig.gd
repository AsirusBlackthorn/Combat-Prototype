# res://resources/CharacterConfig.gd
extends Resource
class_name CharacterConfig

@export var display_name: String = "Character"

# ---- Visual parts ----
@export var body_mesh: Mesh
@export var body_material: Material
@export var body_position: Vector3
@export var body_rotation_degrees: Vector3

@export var head_mesh: Mesh
@export var head_material: Material
@export var head_position: Vector3
@export var head_rotation_degrees: Vector3

# ---- Physics ----
@export var collision_shape: Shape3D
@export var collision_layer: int = 1
@export var collision_mask: int = 1

# ---- Stats ----
@export var stats: Resource  # your CharacterStats resource

# ---- Animation (future use) ----
@export var animation_library: AnimationLibrary
@export var animation_tree: AnimationNodeStateMachine
