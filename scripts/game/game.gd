extends Node

@onready var temperature : float = -273.15
var temperature_delta : float = 1.0
var temperature_timer : float = 0.0
var temperature_time : float = 1.0
var temperature_unfreeze : float = -200.0

@export var player : Node3D

var is_game_over : bool = false

func _ready() -> void:
	AllSignals.jumpscare.connect(_on_jumpscare)

func _on_jumpscare(_player : Node3D) -> void:
	is_game_over = true

func _temperature(delta: float) -> void:
	if temperature >= temperature_unfreeze:
		AllSignals.emit_signal("jumpscare", player)
	else:
		pass
		
	temperature_timer += delta
	
	if temperature_timer >= temperature_time:
		temperature += temperature_delta
		AllSignals.emit_signal("temperature", temperature)

func _process(delta) -> void:
	if is_game_over: return
	_temperature(delta)
