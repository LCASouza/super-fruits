extends Area2D

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("open")
	await get_tree().create_timer(0.7).timeout
	animation.play("idle")

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.portal_entered()
		animation.play("close")
		await get_tree().create_timer(0.6).timeout
		queue_free()
