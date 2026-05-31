# res://states/Movement/MoveState.gd
extends "res://states/State.gd"
# TODO: Rotation doesn't complete after brief input.
# Need to store last direction and keep slerping until aligned,
# even when move_direction is zero. Current _target_basis approach
# needs fixing (rotation stops when input ends).
# Stores the last target direction so rotation completes even after input ends
var _target_basis: Basis
var _has_target: bool = false

func enter() -> void:
	# Reset target basis to current facing direction to prevent snap on state entry
	if character:
		_target_basis = character.basis
		_has_target = true


func air_update(delta: float) -> void:
	if not character:
		return

	var direction: Vector3 = character.move_direction

	if direction.length() > 0.1:
		direction = direction.normalized()
		# Moderate air control factor (50%)
		var target_vel: Vector3 = direction * character.speed * 0.5
		character.velocity.x = move_toward(character.velocity.x, target_vel.x, character.acceleration * 0.2 * delta)
		character.velocity.z = move_toward(character.velocity.z, target_vel.z, character.acceleration * 0.2 * delta)
		# Rotate toward input
		# Flatten to horizontal plane for rotation to avoid rolling when camera is tilted
		var flat_direction: Vector3 = Vector3(direction.x, 0.0, direction.z)
		if flat_direction.length() > 0.0:
			flat_direction = flat_direction.normalized()
			_target_basis = Basis().looking_at(flat_direction, Vector3.UP)
			_has_target = true
		else:
			# If flattened direction is zero (movement purely vertical), don't change target
			pass
	else:
		# No input: keep momentum with light drag
		character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * 0.05 * delta)
		character.velocity.z = move_toward(character.velocity.z, 0.0, character.acceleration * 0.05 * delta)

	# Always rotate toward the last target direction (if we have one)
	if _has_target:
		character.basis = character.basis.slerp(_target_basis, character.rotation_speed * delta)

func physics_update(delta: float) -> void:
	if not character:
		return

	var direction: Vector3 = character.move_direction

	if direction.length() > 0.1:
		direction = direction.normalized()
		# Update the target rotation to face movement direction
		# Flatten to horizontal plane for rotation to avoid rolling when camera is tilted
		var flat_direction := Vector3(direction.x, 0.0, direction.z)
		if flat_direction.length() > 0.0:
			flat_direction = flat_direction.normalized()
			_target_basis = Basis().looking_at(flat_direction, Vector3.UP)
			_has_target = true
		else:
			# If flattened direction is zero, keep current target (no change)
			pass
		# Apply horizontal movement (ground speed)
		character.velocity.x = direction.x * character.speed
		character.velocity.z = direction.z * character.speed
	else:
		# Decelerate to a stop when no movement input/direction is present
		character.velocity.x = move_toward(character.velocity.x, 0.0, character.acceleration * delta)
		character.velocity.z = move_toward(character.velocity.z, 0.0, character.acceleration * delta)

	# Always rotate toward the last target direction (if we have one)
	if _has_target:
		character.basis = character.basis.slerp(_target_basis, character.rotation_speed * delta)
