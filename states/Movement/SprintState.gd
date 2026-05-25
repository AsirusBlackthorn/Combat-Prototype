# res://states/Movement/SprintState.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#SprintState design specification:

#When the player is in movestate and the ui_cancel button is held for a certain minimum duration (eg. 0.35s), enter sprintstate
#Static sprinting animation plays and movement speed increases
#Camera should slowly drift behind the player when their rotation relative to the viewport exceeds a certain angle during this state
#eg. 55 degrees

#Some behaviour will be modified when a character transitions from this state to another, eg. JumpState, PrimaryAction, SecondaryAction
#There will be a few recovery frames after ui_cancel is released. These recovery frames can be cancelled by any movementstate or ActionStates. 
#During recovery, movement speed vector will approach whatever speed corresponds with the left thumbstick input - refer to IdleState, MoveState (and RunState if development of this child proceeds)
#This vector will be updated once per recovery frame unless cancelled.
