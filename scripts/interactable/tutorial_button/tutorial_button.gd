extends Node

var interact_time : float = 0.0
var max_interact_time : float = 1.0
var interacting : bool = false

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.end_tutorial.connect(_on_end_tutorial)

func _on_end_tutorial() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()
func _on_release() -> void:
	pass

func _on_interact(delta) -> void:
	interact_time += delta
	if interact_time >= max_interact_time:
		interact_time = 0.0
		AllSignals.emit_signal("end_tutorial")
