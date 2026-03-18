extends Node2D

@onready var start_button = $HBoxContainer/start_button

func _ready():
	start_button.pressed.connect(start_game)

func start_game():
	# make it wait for the connection here
	get_tree().change_scene_to_file("res://scenes/main.tscn")
