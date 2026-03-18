extends Node2D

@onready var player1_button = $HBoxContainer/player1_button
@onready var player2_button = $HBoxContainer/player2_button

@onready var player1_label = $HBoxContainer2/player1_score
@onready var player2_label = $HBoxContainer2/player2_score

@onready var player1_score = 0
@onready var player2_score = 0

func _ready():
	player1_button.pressed.connect(player1_add)
	player2_button.pressed.connect(player2_add)

func player1_add():
	player1_score += 1
	player1_label.text = str("player 1 clicks:\n",player1_score)
	
func player2_add():
	player2_score += 1
	player2_label.text = str("player 2 clicks:\n",player2_score)
