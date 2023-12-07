extends Area2D

signal get_fruit(quantity)

@export var fruit_type : int

@onready var animation = $AnimationPlayer

func _ready():
	if fruit_type == 0:
		animation.play("maca")
	if fruit_type == 1:
		animation.play("laranja")
	if fruit_type == 2:
		animation.play("morango")
	if fruit_type == 3:
		animation.play("melancia")
	if fruit_type == 4:
		animation.play("banana")


func _on_body_entered(body):
	if body is Player:
		var player = body
		emit_signal("get_fruit", 1)
		animation.play("collected")
		await get_tree().create_timer(0.6).timeout
		queue_free()
