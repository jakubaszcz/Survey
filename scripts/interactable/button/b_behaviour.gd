extends CharacterBody3D

var interact_time : float = 0.0
var max_interact_time : float = 0.5
var interacting : bool = false

var temperature : float = 0.8

@export var success_sound : AudioStreamPlayer3D
@export var error_sound : AudioStreamPlayer3D

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.action_error.connect(_on_action_error)
	AllSignals.action_success.connect(_on_action_success)

func _on_action_error() -> void:
	error_sound.play()

func _on_action_success() -> void:
	success_sound.play()

func _on_interact(delta) -> void:
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("rise_temperature", temperature)
