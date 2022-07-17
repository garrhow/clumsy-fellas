extends StaticBody

export (NodePath) var collision_path
export (NodePath) var mesh_path
export (NodePath) var timer_path
export (NodePath) var tween_path

onready var collision = get_node(collision_path)
onready var mesh = get_node(mesh_path)
onready var timer = get_node(timer_path)
onready var tween = get_node(tween_path)

var destroyed : bool = false
var touched : bool = false

func _on_Timer_timeout():
	if !destroyed:
		destroy_object()
		destroyed = true

func _on_Area_body_entered(body):
	if body.name == "Player" and !destroyed and !touched:
		timer.start()
		play_animation()
		touched = true

func destroy_object():
	collision.queue_free()
	mesh.queue_free()

func play_animation():
	tween.interpolate_property(mesh, "scale",
		mesh.scale, Vector3.ZERO, 1.5,
		Tween.TRANS_BOUNCE)
	tween.start()
