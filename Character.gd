extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Character.gd design specification:

#Manage logic that is shared by all characters in game
#Including the application of physics processes, ContactStates, MovementStates etc
#Consider developing another child that includes characters which can damage the player and be damaged by them, but is hostile to enemies and not the player
#If possible, use the same AiBehaviourMachine, just designed to target Enemies and not the player
