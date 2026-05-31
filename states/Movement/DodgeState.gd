# res://states/Movement/DodgeState.gd
extends "res://states/State.gd"

@export var dodge_distance: float = 3.0
@export var dodge_duration: float = 0.35
@export var buffer_window: float = 0.1  # Last X seconds — inputs are buffered

var _dodge_timer: float = 0.0
var _dodge_speed: float = 0.0
var _dodge_direction: Vector3 = Vector3.ZERO
var _buffered_state: String = ""  # Next state to enter when dodge ends
# Stores direction for a buffered dodge (set during buffer window, consumed on next enter)
var _queued_dodge_direction: Vector3 = Vector3.ZERO
var _has_queued_direction: bool = false
# Stores direction for a buffered jump (set during buffer window, read by JumpState)
var _queued_jump_direction: Vector3 = Vector3.ZERO
var _has_queued_jump_direction: bool = false
func enter() -> void:
	# Block re-entry while a dodge is still in progress
	if _dodge_timer > 0.0:
		return
	# If airborne, consume an air action (air dodge)
	if character and not character.is_on_floor():
		if not consume_air_action():
			return  # No air actions – can't air dodge

	_dodge_timer = dodge_duration
	_dodge_speed = dodge_distance / dodge_duration
	_buffered_state = ""  # Clear any leftover buffer

	# Use queued direction if available (from previous dodge's buffer window)
	if _has_queued_direction:
		_dodge_direction = _queued_dodge_direction
		_has_queued_direction = false
	else:
		# Fallback to current move direction or facing (flatten to horizontal)
		if character.move_direction.length() > 0.1:
			var dir: Vector3 = character.move_direction.normalized()
			_dodge_direction = Vector3(dir.x, 0.0, dir.z).normalized()
		else:
			var face: Vector3 = -character.global_basis.z
			_dodge_direction = Vector3(face.x, 0.0, face.z).normalized()


func exit() -> void:
	# Zero horizontal velocity so the next state starts fresh
	if character:
		character.velocity.x = 0.0
		character.velocity.z = 0.0
func physics_update(delta: float) -> void:
	if not character:
		return

	_dodge_timer -= delta

	character.velocity.x = _dodge_direction.x * _dodge_speed
	character.velocity.z = _dodge_direction.z * _dodge_speed
	character.velocity.y = 0.0

	# Flatten dodge direction for rotation to avoid roll from vertical components
	var rotation_dir: Vector3 = Vector3(_dodge_direction.x, 0.0, _dodge_direction.z)
	if rotation_dir.length() < 0.01:
		var fallback_face: Vector3 = -character.global_basis.z
		rotation_dir = Vector3(fallback_face.x, 0.0, fallback_face.z).normalized()
	else:
		rotation_dir = rotation_dir.normalized()
	var target_basis: Basis = Basis().looking_at(rotation_dir, Vector3.UP)
	character.basis = character.basis.slerp(target_basis, character.rotation_speed * delta)
	# Buffer window: capture inputs near the end of the current dodge
	if _dodge_timer <= buffer_window and _dodge_timer > 0.0:
		# Dodge input
		if Input.is_action_just_pressed("ui_cancel"):
			_buffered_state = "DodgeState"
			# Capture direction at the moment of input
			if character.move_direction.length() > 0.1:
				var qdir: Vector3 = character.move_direction.normalized()
				_queued_dodge_direction = Vector3(qdir.x, 0.0, qdir.z).normalized()
			else:
				var qface: Vector3 = -character.global_basis.z
				_queued_dodge_direction = Vector3(qface.x, 0.0, qface.z).normalized()
			_has_queued_direction = true

		# Jump input
		if Input.is_action_just_pressed("ui_accept"):
			_buffered_state = "JumpState"
			# Capture direction for the upcoming jump so JumpState can use it
			if character.move_direction.length() > 0.1:
				var jdir: Vector3 = character.move_direction.normalized()
				_queued_jump_direction = Vector3(jdir.x, 0.0, jdir.z).normalized()
			else:
				var jface: Vector3 = -character.global_basis.z
				_queued_jump_direction = Vector3(jface.x, 0.0, jface.z).normalized()
			_has_queued_jump_direction = true
	# End dodge when timer expires
	if _dodge_timer <= 0.0:
		var movement_sm = character.state_machine.get_node_or_null("MovementStates")
		if movement_sm:
			if _buffered_state != "":
				movement_sm.transition_to(_buffered_state)
				_buffered_state = ""
			else:
				var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
				if input_dir.length() > 0.1:
					movement_sm.transition_to("MoveState")
				else:
					movement_sm.transition_to("IdleState")
