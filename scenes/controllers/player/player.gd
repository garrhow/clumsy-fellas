extends KinematicBody

## Enables debug mode.
export var show_debug : bool = true

# Node paths
export var camera : NodePath
export var camera_direction : NodePath
export var debug_gui : NodePath
export var pivot : NodePath

var character_rotation_direction : Vector3

# Physics-based floats
var acceleration : float = 12
var gravity : float = 24
var jump_force : float = 10
var speed : float = 6

# Physics-based 3D vectors
var direction : Vector3 = Vector3.ZERO
var movement : Vector3 = Vector3.ZERO
var movement_input : Vector3 = Vector3.ZERO
var velocity : Vector3 = Vector3.ZERO

# States
var diving : bool
var grounded : bool
var jumping : bool

func _process(_delta):
	debug_info()

func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: process_input()
	process_movement(delta)

func process_input():
	movement_input.x = Input.get_axis("move_forward", "move_back")
	movement_input.y = Input.get_axis("move_left", "move_right")
	
	if is_on_floor() and Input.is_action_just_pressed("jump") and !jumping:
		jumping = true
	
	if Input.is_action_just_pressed("dive") and !diving:
		diving = true

func process_rotation():
	if character_rotation_direction == null:
		character_rotation_direction = direction
	else:
		if direction != Vector3.ZERO:
			character_rotation_direction = direction
		
	get_node(pivot).rotation.y = lerp_angle(
		get_node(pivot).rotation.y, atan2(
			-(global_transform.basis.z + character_rotation_direction).x,
			-(global_transform.basis.x + character_rotation_direction).z
		), 0.2)

func process_movement(delta : float):
	direction = movement_input.x * get_node(camera_direction).global_transform.basis.z + movement_input.y * get_node(camera_direction).global_transform.basis.x
	direction = direction.normalized()
	movement = movement.linear_interpolate(direction * speed, acceleration * delta)
	
	# Character rotation
	process_rotation()
	
	# Ground velocity
	velocity.x = movement.x
	velocity.z = movement.z
	
	# Vertical velocity
	if jumping:
		velocity.y += jump_force
	velocity.y += Vector3.DOWN.y * gravity * delta
	
	if diving:
		pass # velocity += -global_transform.origin.direction_to(get_node(pivot).transform.origin) * speed
	
	if is_on_floor():
		diving = false
		jumping = false
	
	velocity = move_and_slide(velocity, Vector3.UP, true)

func debug_info():
	# Show or hide the debug info
	if show_debug: get_node(debug_gui).visible = true
	else: get_node(debug_gui).visible = false
	
	# Apply values to debug info
	get_node(debug_gui).get_node("Direction").text = "Direction: " + str(direction.round())
	get_node(debug_gui).get_node("Velocity").text = "Velocity: " + str(velocity.round())
