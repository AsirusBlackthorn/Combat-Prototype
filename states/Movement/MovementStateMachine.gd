# res://states/Movement/MovementStateMachine.gd
extends "res://states/State.gd"

# Sub-state machine for movement states
# Acts as both a State (to parent StateMachine) and a state machine (to its children)

var _sub_states: Dictionary = {}
var _current_sub_state: Node = null
var _was_airborne: bool = false

func _ready() -> void:
	# Register all child movement states
	_register_sub_states(self)
 	
	# Enter IdleState by default
	if _sub_states.has("IdleState"):
		transition_to("IdleState")

# Called by parent StateMachine when entering this sub-machine
func enter() -> void:
	if _current_sub_state and _current_sub_state.has_method("enter"):
		_current_sub_state.enter()

# Called by parent StateMachine when exiting this sub-machine
func exit() -> void:
	if _current_sub_state and _current_sub_state.has_method("exit"):
		_current_sub_state.exit()

# Called by parent StateMachine's update()
func update(delta: float) -> void:
	if _current_sub_state and _current_sub_state.has_method("update"):
		_current_sub_state.update(delta)

# Called by parent StateMachine's physics_update()
func physics_update(delta: float) -> void:
	if not _current_sub_state or not character:
		return
 	
	# 1. Ground physics
	if _current_sub_state.has_method("physics_update"):
		_current_sub_state.physics_update(delta)

	# 2. Airborne handling (if not on floor)
	var on_floor: bool = character.is_on_floor()

	if not on_floor:
		# Call the sub-state's air_update (each state controls its own air drift)
		if _current_sub_state.has_method("air_update"):
			_current_sub_state.air_update(delta)

		_was_airborne = true
		return

	# 3. Landing detection: we were airborne and now on floor
	if _was_airborne and on_floor:
		_was_airborne = false
		_on_landing()

# Called when the player lands after being airborne
func _on_landing() -> void:
	if not character:
		return
	character.air_actions_remaining = character.max_air_actions

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir.length() > 0.1:
		transition_to("MoveState")
	else:
		transition_to("IdleState")

# Public: check if player is airborne (useful for other state machines)
func is_airborne() -> bool:
	return _was_airborne
func can_perform_air_action() -> bool:
	return character.air_actions_remaining > 0 if character else false

func transition_to(state_name: String) -> void:
	if not _sub_states.has(state_name):
		push_warning("MovementStateMachine: No sub-state named '%s' found." % state_name)
		return
 	
	var new_state = _sub_states[state_name]
 	
	# Exit current sub-state
	if _current_sub_state and _current_sub_state.has_method("exit"):
		_current_sub_state.exit()
 	
	# Enter new sub-state
	_current_sub_state = new_state
	# Reset airborne flag when entering a new sub-state
	_was_airborne = not character.is_on_floor() if character else false
	if _current_sub_state.has_method("enter"):
		_current_sub_state.enter()

# Returns the name of the current sub-state (useful for debugging)
func get_current_state_name() -> String:
	return _current_sub_state.name if _current_sub_state else "None"

# Register all child State nodes as sub-states
func _register_sub_states(node: Node) -> void:
	for child in node.get_children():
		if child is State:
			child.character = character
			_sub_states[child.name] = child
		# Recurse into child nodes (e.g., RunState, SprintState under MoveState)
		_register_sub_states(child)
