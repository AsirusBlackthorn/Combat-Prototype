# DESIGN BRIEF - Character Rig Definition (Resource)
# 
# Purpose: Defines a hierarchical skeleton of bones for a character.
# Each bone has: name, parent_index, length, width (capsule radius),
# local offset/rotation, collision shape type, and optional mesh.
#
# The Character.gd apply_config() will be refactored to read this
# tree and dynamically spawn Bone3D nodes with child CollisionShape3D
# and MeshInstance3D, parented correctly.
#
# Supports any number of bones, any shape/size character.
# Example: humanoid (12+ bones), Quelaag-style spider (many legs),
# or a simple 2-bone enemy.
#
# Fields needed:
# - bones: Array[BoneData] (each BoneData is a custom Resource)
# - BoneData: name, parent_index, length, width, offset, rotation, shape_type (CAPSULE/BOX/SPHERE), mesh_override
#
# Implementation target: When the rig system becomes priority.

extends Resource
class_name CharacterRigDefinition

# Example structure (to be implemented):
# @export var bones: Array[BoneDefinition] = []
#
# class BoneDefinition:
#     var name: String = ""
#     var parent_index: int = -1  # -1 = root
#     var length: float = 0.5
#     var width: float = 0.2
#     var local_offset: Vector3 = Vector3.ZERO
#     var local_rotation: Vector3 = Vector3.ZERO
#     var shape_type: int = 0  # 0=CAPSULE, 1=BOX, 2=SPHERE
#     var mesh: Mesh = null  # optional visual proxy