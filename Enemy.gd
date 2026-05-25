extends "res://Character.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Enemy.gd design specification:

#Essentially works the same way as Player.gd, except uses the AiBehaviourMachine in place of controller inputs
#Raycast in a field with variable AwarnessRadius or similar to drive transition from PassiveState to HostileState
#Consider logic required to transition into AlertState:
#Perhaps if the enemy loses line of sight for a certain duration, or they receive somemother stimulus than their awareness field being entered.
#Consider raycasting in a cone in front, and a small sphere, capsule or cyclinder to cover their blind spots

#If there are many enemies in a scene, does the enemy node require duplication each time?
#Or, would it be possible to create many instances of the same node?
#Is it possible to utilise data driven design to create many enemies with unique stats, models and behaviour variable variations without duplicating the enemy node at all?
