# res://resources/BoundaryConfig.gd
class_name BoundaryConfig
extends Resource

## One mesh per boundary piece (floor, wall, etc.)
@export var meshes: Array[Mesh]

## One collision shape per mesh (same order)
@export var shapes: Array[Shape3D]
## Optional transform (position, rotation, scale) per piece
@export var transforms: Array[Transform3D]
