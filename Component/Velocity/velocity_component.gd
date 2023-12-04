extends Node
class_name VelocityComponent

@export var max_speed: int = 200
@export var acceleration: float = 5
@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.2
@export var jump_time_to_descent : float = 0.4

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var velocity = Vector2.ZERO


func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1-exp(-acceleration * get_process_delta_time()))


func accelerate_in_direction_with_gravity(x_direction: float):
	# Aplicando a gravidade no eixo y
	velocity.y += get_gravity() * get_process_delta_time()
	
	# Calculando a velocidade desejada no eixo x
	var desired_velocity = x_direction * max_speed
	
	# Interpolando a velocidade atual no eixo x com a velocidade desejada
	velocity.x = lerp(velocity.x, desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func jump():
	velocity.y = jump_velocity


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func decelarate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
