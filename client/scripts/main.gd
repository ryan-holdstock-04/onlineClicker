extends Node2D

@onready var player1_button = $HBoxContainer/player1_button
#@onready var player2_button = $HBoxContainer/player2_button

@onready var player1_label = $HBoxContainer2/player1_score
@onready var player2_label = $HBoxContainer2/player2_score

@onready var player1_score = 0
@onready var player2_score = 0

# Setup socket vars
var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED


func _ready():
	player1_button.pressed.connect(player1_add)
	#player2_button.pressed.connect(player2_add)
	simple_loop()
	# Connect To server
	var err = socket.connect_to_url("ws://localhost:8080")
	
	if err != OK:
		print("Could not connect")
	else:
		print("Connection successful")
	

func _process(_delta):
	
	# init socket
	socket.poll()
	var state = socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			var data_string = packet.get_string_from_utf8()
			var data = JSON.parse_string(data_string)
			
			if data and data.has("value"):
				player2_add(data["value"])
				

	# Detect connection/disconnection for debugging
	if state != last_state:
		print("Connection state changed: ", state)
		last_state = state
	
	if Input.is_action_just_pressed("player1_press"):
		player1_add()
	
	

func player1_add():
	player1_score += 1
	player1_label.text = str("player 1 clicks:\n",player1_score)
	
func player2_add(value):
	player2_score = value
	player2_label.text = str("player 2 clicks:\n",player2_score)
	
func simple_loop():
	var counter = 0
	while true:
		counter += 1
		await get_tree().create_timer(1.0).timeout
		var msg = JSON.stringify({"action": "increment"})
		socket.send_text(msg)
	
