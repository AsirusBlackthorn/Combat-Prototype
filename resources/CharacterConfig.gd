extends Resource
class_name CharacterConfig

@export var display_name: String = "Character"

# Visual
@export var mesh: Mesh
@export var material_override: Material

# Physics
@export var collision_shape: Shape3D
@export var collision_layer: int = 1
@export var collision_mask: int = 1

# Stats
@export var stats: Resource  # Your CharacterStats resource

# Animation
@export var animation_library: AnimationLibrary
@export var animation_tree: AnimationNodeStateMachine  # Or AnimationNodeBlendTree