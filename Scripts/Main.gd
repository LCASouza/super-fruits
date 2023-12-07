class_name GameManager extends Node2D

const lines: Array[String] = [
	"Pegue todas as frutas para conseguir entrar no portal!
	 Pressione F para continuar."
]

var portal_scene = preload("res://Scenes/Portal.tscn")

@onready var hud = $UI/UI
@onready var player = $Player
@onready var frutas = $Frutas
@onready var bullets = $Bullets
@onready var enemies = $Plants
@onready var dialog_position = $DialogPosition
@onready var portal = $Portal
@onready var audio = $AudioStreamPlayer

@export var fruits_necessary := 0

var dialog_created : bool = false
var portal_opened : bool = false

var fruits := 0:
	set(value):
		fruits = value
		hud.fruits = fruits

func add_fruits(quantity):
	fruits += quantity

func _ready():
	fruits = 0
	hud.max_fruits = fruits_necessary
	
	for enemy in enemies.get_children():
		enemy.connect("bullet_shot", _on_enemy_bullet_shot)
	
	for fruit in frutas.get_children():
		fruit.connect("get_fruit", add_fruits)
	
	hud.connect("mute_sound", mute_sound)

func _process(delta):
	if !dialog_created:
		DialogManager.start_dialog(dialog_position.global_position, lines)
		dialog_created = true
	
	if fruits == fruits_necessary && portal_opened == false:
		open_portal()
		portal_opened = true

func _on_enemy_bullet_shot(Bullet):
	bullets.add_child(Bullet)

func open_portal():
	var instance = portal_scene.instantiate()
	instance.position = portal.position
	instance.rotation = portal.rotation
	add_child(instance)

func mute_sound():
	if audio.playing:
		audio.stop()
	else:
		audio.play()
