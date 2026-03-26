extends CharacterBody3D


var interact_time : float = 0.0
var max_interact_time : float = 1.0
var interacting : bool = false

var fluid : int = 2

@onready var has_power : bool = true

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.generator_state.connect(_on_generator_state)

func _on_generator_state(state: bool) -> void:
	has_power = state

func _on_interact(delta) -> void:
	if not has_power: return
	interacting = true
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("rise_fluid", fluid)
