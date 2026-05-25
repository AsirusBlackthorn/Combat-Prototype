# res://states/Movement/MoveState.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Movestate design specification:

#Supersede omnidirectional movement controls currently found in player.gd
#Export character movement speed vector for use by other related scripts
#I assume that the movement of the player in this state should always be driven by a movement speed variable
#Therefore any animations associated with this state or its siblings would be static

#Consider whether it is preferable to assign two different animation:
#Slow walking (light thumbstick input, eg up to 60%),
#And jog/ light run (eg. 60-100% thumbstick input)

#Or, would it be preferable to assign two children to movestate, so all three states are assigned their own animation:
#Walking animation - Movestate
#Jogging/ light running animation: RunState
#Sprinting animation: SprintState

#Bear in mind that sprinting will require holding the ui_cancel button (timing based).
#This will require modified camera behaviour - as the player's right thumb will be occupied, the camera should gently drift behind the player to correspond with left and right movement inputs.
