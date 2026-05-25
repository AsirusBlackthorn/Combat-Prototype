# res://states/Movement/IdleState.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#IdleState design specification:

#Initial state of movement state machine.

#Include scope for idle behaviour, eg. after 30 seconds in IdleState, player begins to perform a list of behaviours at random: 
#Look around, put hands on hips, sit down etc.
#Create an interval between animations eg. 20 second buffer, so it doesn't seem like the idle character is goimg mad
#Consider a placeholder eg. rotation about y axis 3 times - only if it is easy to replace with a rigged animation later.
#If idle animations are beyond the scope of this development stage, keep a note in this script for it to be integrated later.
