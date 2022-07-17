extends StaticBody

export (bool) var enabled = true

var destroyed : bool = false
var touched : bool = false

func _physics_process(_delta):
	if $Area.get_overlapping_bodies().size() > 1 and !destroyed and !touched and enabled:
		$Timer.start()
		play_animation()
		touched = true

func _on_Timer_timeout():
	if !destroyed:
		destroy_object()
		destroyed = true

func destroy_object():
	$Collision.queue_free()
	$Mesh.queue_free()

func play_animation():
	$Tween.interpolate_property($Mesh, "scale",
		$Mesh.scale, Vector3.ZERO, 1.5,
		Tween.TRANS_BOUNCE)
	$Tween.start()
