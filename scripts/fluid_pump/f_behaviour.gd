extends CharacterBody3D


var interact_time : float = 0.0
var max_interact_time : float = 0.5
var interacting : bool = false

var fluid : int = 1

@onready var has_power : bool = true

@export var error : AudioStreamPlayer3D
@export var success : AudioStreamPlayer3D

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.generator_state.connect(_on_generator_state)
	AllSignals.action_success.connect(_on_action_success)
	AllSignals.action_error.connect(_on_action_error)

func _on_action_success() -> void:
	success.play()

func _on_action_error() -> void:
	error.play()

func _on_generator_state(state: bool) -> void:
	has_power = not state

func _on_release() -> void:
	AllSignals.emit_signal("cooling_end")

func _on_interact(delta) -> void:
	if not has_power: return
	AllSignals.emit_signal("cooling_start")
	interacting = true
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("rise_fluid", fluid)
