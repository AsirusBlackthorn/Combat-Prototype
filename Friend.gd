# res://Friend.gd
@tool
extends Character

# Extend base class 'Character' (defined with class_name Character in Character.gd)
# Define unique behaviour, e.g., assists player or avoids combat
@export var friendly_speed: float = 5.0

func _ready() -> void:
	super()  # Call Character._ready() to ensure apply_config() runs
	# Initialize friend-specific state here
	pass

func assist_player(target) -> void:
	# TODO: implement assistance behavior
	pass
