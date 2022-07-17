extends Camera

export var horizontal_pivot : NodePath
export var vertical_pivot : NodePath

export var max_vertical_rotation : float = 75
export var min_vertical_rotation : float = 15

export var mouse_sensitivity : float = 15

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):         
	if event is InputEventMouseMotion:
		var camera_rotation : Vector2 = -event.relative * mouse_sensitivity / 100
		get_node(horizontal_pivot).rotation_degrees.y += camera_rotation.x
		get_node(vertical_pivot).rotation_degrees.x = clamp(
			get_node(vertical_pivot).rotation_degrees.x + camera_rotation.y,
			-max_vertical_rotation, min_vertical_rotation
		)
