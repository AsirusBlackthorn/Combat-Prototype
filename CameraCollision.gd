extends "res://CameraController.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Script specification:

# Primary function is to prevent camera from clipping through other mesh objects.

#When colliding with objects in the LevelBoundary family, the camera should smoothly slide towards the player.
#When colliding with other entities in the Character family, the camera should smoothly slide away from the player to include them in the viewport foreground
#Therefore consider a horn-shaped collision object, pointing towards the player, with the wider base extending behind the camera, to reduce rapid camera sliding when panning past characters in the foreground
#Also consider designing the forwards/backwards sliding behaviour to be timing based, to further limit rapid or janky sliding.
#When camera is caught between a Character and a LevelBoundary, hard-code to slide in front of the character to reduce janky behaviour.
