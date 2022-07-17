extends KinematicBody

export var acceleration : float = 100

var speed : float = 0

func _process(delta):
	speed += acceleration * delta
	rotation_degrees.y = speed
