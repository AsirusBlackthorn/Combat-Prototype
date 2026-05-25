# res://states/Movement/MovementStateMachine.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#MovementStateMachine design specification:

#Manage transitions between movement states, 3D animations, and frame data - consider utilising data-driven design to reduce hard-coding requirements.
#Also consider utilisimg hard-coding for the sake of simplicity during early development
#Consider using blank placeholders for 3D animations until after working logic has been developed.
