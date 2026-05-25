# res://states/StateMachine.gd
extends Node

# Dictionary of all registered states: { "StateName": State node }
var states: Dictionary = {}

# The currently active state node.
var current_state: Node = null

func _ready() -> void:
	# Register all child State nodes
	_register_states(self)

	# Enter the first available state as default
	if states.size() > 0:
		var first_key = states.keys()[0]
		transition_to(first_key)

func _process(delta: float) -> void:
	if current_state and current_state.has_method("update"):
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("physics_update"):
		current_state.physics_update(delta)

# Recursively find all State nodes and register them.
func _register_states(node: Node) -> void:
	for child in node.get_children():
		if child is State:
			child.character = _find_character()
			states[child.name] = child
		# Recurse into child nodes to find nested states
		_register_states(child)

# Transition to a new state by name.
func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("StateMachine: No state named '%s' found." % state_name)
		return

	var new_state = states[state_name]

	# Exit the current state
	if current_state and current_state.has_method("exit"):
		current_state.exit()

	# Enter the new state
	current_state = new_state
	if current_state.has_method("enter"):
		current_state.enter()

# Walk up the tree to find the Character node.
func _find_character() -> Node:
	var node = get_parent()
	while node:
		if node.is_in_group("character") or node is CharacterBody3D:
			return node
		node = node.get_parent()
	return null
