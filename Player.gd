# res://Player.gd
@tool

extends Character

# Sprint/Dodge shared input handling
var _cancel_press_time: float = -1.0
var _is_sprinting: bool = false
const SPRINT_HOLD_THRESHOLD: float = 0.3
const DODGE_DURATION: float = 0.4

func _physics_process(delta: float) -> void:
	# Call parent Character physics first (handles gravity, state machine, move_and_slide)
	# The parent already returns early if Engine.is_editor_hint()
	super(delta)

	# Only run input/transition logic at runtime
	if Engine.is_editor_hint():
		return

	# Now handle transitions (only if state machine exists)
	if not state_machine:
		return

	var movement_sm := state_machine.get_node_or_null("MovementStates")
	if not movement_sm:
		return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	var camera = get_viewport().get_camera_3d()
	if camera:
		var forward = camera.global_basis.z
		var right = camera.global_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		move_direction = forward * input_dir.y + right * input_dir.x
	else:
		move_direction = Vector3.ZERO

	var is_moving := input_dir.length() > 0.1
	var on_floor := is_on_floor()
	var current_state: String = movement_sm.get_current_state_name()

	# --- Sprint/Dodge shared input logic ---
	_handle_cancel_input(delta, movement_sm, current_state, on_floor)

	# --- Jump input ---
	var jump_pressed := Input.is_action_just_pressed("ui_accept")
	if jump_pressed:
		if on_floor and current_state in ["IdleState", "MoveState", "SprintState"]:
			movement_sm.transition_to("JumpState")
		elif not on_floor and movement_sm and movement_sm.has_method("can_perform_air_action") and movement_sm.can_perform_air_action():
			# Airborne double-jump – MovementStateMachine should expose can_perform_air_action()
			movement_sm.transition_to("JumpState")
	# --- State transitions (excluding sprint/dodge which are handled above) ---
	match current_state:
		"IdleState":
			if is_moving and not _is_sprinting:
				movement_sm.transition_to("MoveState")
		"MoveState":
			if not is_moving and not _is_sprinting:
				movement_sm.transition_to("IdleState")
		"DodgeState":
			# DodgeState handles its own exit via timer
			pass
		"SprintState":
			# SprintState handles its own movement; exit on release is handled above
			pass


func _handle_cancel_input(delta: float, movement_sm: Node, current_state: String, on_floor: bool) -> void:
	var cancel_just_pressed := Input.is_action_just_pressed("ui_cancel")
	var cancel_held := Input.is_action_pressed("ui_cancel")
	var cancel_just_released := Input.is_action_just_released("ui_cancel")

	if cancel_just_pressed:
		_cancel_press_time = Time.get_ticks_msec() / 1000.0

	if cancel_held and on_floor:
		var hold_time = (Time.get_ticks_msec() / 1000.0) - _cancel_press_time
		if hold_time >= SPRINT_HOLD_THRESHOLD and not _is_sprinting:
			# Start sprinting
			_is_sprinting = true
			if current_state in ["IdleState", "MoveState"]:
				movement_sm.transition_to("SprintState")

	if cancel_just_released:
		if _cancel_press_time > 0:
			var hold_time = (Time.get_ticks_msec() / 1000.0) - _cancel_press_time
			if hold_time < SPRINT_HOLD_THRESHOLD:
				# Quick tap -> dodge
				movement_sm.transition_to("DodgeState")
			elif _is_sprinting:
				# Release after sprint -> stop sprinting
				_is_sprinting = false
				# Transition back to appropriate state
				var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
				if input_dir.length() > 0.1:
					movement_sm.transition_to("MoveState")
				else:
					movement_sm.transition_to("IdleState")
		_cancel_press_time = -1.0

	# If we lose floor while sprinting, stop sprinting
	if _is_sprinting and not on_floor:
		_is_sprinting = false

# Called by SprintState when turning too sharply
func stop_sprint() -> void:
	_is_sprinting = false
	# Reset press timer so the player must hold again for 0.3s
	_cancel_press_time = Time.get_ticks_msec() / 1000.0
