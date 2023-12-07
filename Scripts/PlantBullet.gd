extends Area2D

@export var velocidade := 1500.0

var movement_vector := Vector2(-1, 0)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * velocidade * delta

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()
	
	queue_free()
