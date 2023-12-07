class_name Player extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	HIT
}

@export var max_jumps: int = 1
@export var scene : int = 0

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var animation_player = $AnimationPlayer
@onready var particle_run_spawn = $ParticleRun
@export var particle_run_effect : PackedScene

var jump_count: int = 0
var current_state: State = State.IDLE
var dont_move: bool = false

func _process(_delta):
	if !dont_move:
		var movement_x_vector = get_input_velocity()
		verify_vertical_input()
		velocity_component.accelerate_in_direction_with_gravity(movement_x_vector)
		velocity_component.move(self)
		handle_state(movement_x_vector)

func handle_state(movement_x_vector: float):
	match current_state:
		State.IDLE:
			handle_idle(movement_x_vector)
		State.RUN:
			particle_run_instantiate()
			handle_run(movement_x_vector)
		State.JUMP:
			handle_jump()
		State.FALL:
			handle_fall()
		State.HIT:
			handle_hit()
	update_visuals(movement_x_vector)
	update_animation()

func handle_idle(movement_x_vector: float):
	if movement_x_vector != 0:
		current_state = State.RUN
	elif not is_on_floor():
		current_state = State.FALL

func handle_run(movement_x_vector: float):
	if movement_x_vector == 0:
		current_state = State.IDLE
	elif not is_on_floor():
		current_state = State.FALL

func handle_jump():
	if is_on_floor():
		current_state = State.IDLE
	elif velocity.y > 0:
		current_state = State.FALL

func handle_fall():
	if is_on_floor():
		current_state = State.IDLE

func handle_hit():
	dont_move = true
	current_state = State.HIT

func update_visuals(movement_x_vector: float):
	if movement_x_vector != 0:
		visuals.scale.x = sign(movement_x_vector)

func update_animation():
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			animation_player.play("jump")
		State.FALL:
			animation_player.play("fall")
		State.HIT:
			animation_player.play("hit")

func verify_vertical_input():
	if is_on_floor():
		if Input.is_action_pressed("move_down"):
			drop_down()
		jump_count = 0
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		current_state = State.JUMP
		jump_count += 1
		velocity_component.jump()

func drop_down():
	position.y += 2

func get_input_velocity() -> float:
	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return horizontal



var current_health := 100
var max_health := 100

func lose_health(damage):
	current_health -= damage
	
	if current_health < 0:
		die()

func die():
	current_state = State.HIT
	await get_tree().create_timer(0.6).timeout
	queue_free()
	get_tree().reload_current_scene()

func portal_entered():
	current_state = State.HIT
	await get_tree().create_timer(0.6).timeout
	queue_free()
	if scene == 0:
		get_tree().change_scene_to_file("res://Scenes/SecondLevel.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Fim.tscn")

func particle_run_instantiate():
	var particle = particle_run_effect.instantiate()
	particle.position = particle_run_spawn.global_position
	particle.rotation = particle_run_spawn.global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
