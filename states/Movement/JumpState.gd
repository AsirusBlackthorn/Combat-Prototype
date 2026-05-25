# res://states/Movement/JumpState.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#JumpState design specification:

#Will supersede jumping logic currently found in Player.gd
#Consider dividing specified logic with an 'InAirState'

#Can transition from IdleState, MoveState and its children

#Read exported movement speed vector and preserve momentum
#Omnidirectional movement logic will be preserved during air control, however stricly limited:
#eg rotation and translation speed limited to 10-25%
#Include 'coyote time' in design scope


#During ChargeState1-4 and while InAir is true, the player can perform two of the three following manouvres:
#Double jump, Air-dash and special attack
#Two manouvres csn be performed, but each must be different - hence, the player cannot 'triple jump' or air dash twice.
#The player will have access to multiple special attacks, but again only two can be performed and each must be different.
#Normal attacks (PrimaryAction and SecondaryAction) will interrupt the application of gravity on Characters
#This applies both when the character hits or is hit by a target - this behaviour should therefore apply both to the player and enemies.

#Can cancel the startup frames of ActionStates
#Can cancel the recovery frames of ActionStates, ContactStates, DodgeState and SprintState

#During ChargeState1-4:
#Jumping animations will be modified, create area-of-effect hitboxes, possibly affect i-frames - perhaps more
#Can cancel active frames of DodgeState, PrimaryState and SecondaryState (if equipment allows)
#Can be cancelled during startup by PrimaryState and SecondaryState (if equipment allows) - results in a launching attack
