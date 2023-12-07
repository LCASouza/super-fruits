extends Area2D

signal bullet_shot(Bullet)

enum State {
	IDLE,
	ATTACK
}

@onready var shot_instantiate = $ShotInstantiate
@onready var animation = $AnimationPlayer

@export_range(1.0, 5.0) var fire_rate : float
@export var random : bool = false
@export_range(1.0, 5.0) var random_fire_initial : float
@export_range(1.0, 5.0) var random_fire_final : float

var bullet_scene = preload("res://Scenes/PlantBullet.tscn")

var current_state: State = State.IDLE
var shoot_cooldown := false

func _ready():
	pass

func _process(delta):
	if !shoot_cooldown:
			shoot_cooldown = true
			shot_bullet()
			if random:
				await get_tree().create_timer(randf_range(random_fire_initial, random_fire_final)).timeout
			else:
				await get_tree().create_timer(fire_rate).timeout
			shoot_cooldown = false
	
	update_animation()

func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()

func update_animation():
	match current_state:
		State.IDLE:
			animation.play("idle")
		State.ATTACK:
			animation.play("attack")

func shot_bullet():
	current_state = State.ATTACK
	
	await get_tree().create_timer(0.4).timeout
	
	var bl = bullet_scene.instantiate()
	bl.global_position = shot_instantiate.global_position
	bl.rotation = rotation
	emit_signal("bullet_shot", bl)
	
	await get_tree().create_timer(0.4).timeout
	
	current_state = State.IDLE

