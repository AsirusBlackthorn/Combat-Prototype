# res://states/Movement/DodgeState.gd
extends "res://states/State.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#DodgeState design specification:

#Characters can transition into DodgeState from IdleState, MoveState, RunState, or the recovery frames of SprintState or ActionStates and ContactStates.
#Character movement in this state should probably be animation driven.
#If this cannot be scripted, define a fixed DodgeLength variable or similar and save the animation-driven design as a note to implement later.

#Recovery frames can be cancelled by another dodge input, JumpState, PrimaryState, SecondaryState, or EssenceState. The behaviour of PrimaryState will be modified in this case (dodge attack) and sometimes SecondaryState too (depending on the character's equipment)
#Can cancel startup frames of ActionStates

#During ChargeState1-4:
#Dodging animations will be modified, create area-of-effect hitboxes, possibly affect i-frames - perhaps more
#Can air-dash once while InAir is true (or OnGround is false - I should probably use only one) 
#Can transition to PrimaryState (results in dashing attacks, also works for SecondaryState is equipment is suitable)
