extends CharacterBody3D

var interact_time : float = 0.0
var max_interact_time : float = 1.0
var interacting : bool = false

var temperature : float = 1.0

func _ready() -> void:
	add_to_group("interactable")

func _on_interact(delta) -> void:
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("rise_temperature", temperature)
