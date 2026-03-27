extends CharacterBody3D

var interact_time : float = 0.0
var max_interact_time : float = 0.5
var interacting : bool = false

var temperature : float = 0.8

@export var success_sound : AudioStreamPlayer3D
@export var error_sound : AudioStreamPlayer3D

@onready var has_power : bool = true

@onready var game_type : GameType.Type = GameType.Type.Tutorial

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.action_error.connect(_on_action_error)
	AllSignals.action_success.connect(_on_action_success)
	AllSignals.generator_state.connect(_on_generator_state)
	AllSignals.end_tutorial.connect(_on_end_tutorial)

func _on_end_tutorial() -> void:
	game_type = GameType.Type.Game

func _on_generator_state(state: bool) -> void:
	has_power = not state

func _on_action_error() -> void:
	error_sound.play()

func _on_action_success() -> void:
	success_sound.play()

func _on_release() -> void:
	if game_type == GameType.Type.Tutorial: return
	AllSignals.emit_signal("heat_end")

func _on_interact(delta) -> void:
	if game_type == GameType.Type.Tutorial: return
	if not has_power: return
	AllSignals.emit_signal("heat_start")
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("rise_temperature", temperature)
