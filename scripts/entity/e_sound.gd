extends Node

@export var jumpscare : AudioStreamPlayer3D

func _ready() -> void:
	AllSignals.jumpscare.connect(_on_jumpscare)


func _on_jumpscare(player : Node3D) -> void:
	print("haha")
	jumpscare.play()
