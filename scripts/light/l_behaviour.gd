extends Node

@export var light_1: OmniLight3D
@export var light_2: OmniLight3D

enum states {
	On,
	Off
}

@onready var lights_state: states = states.On

func _ready() -> void:
	AllSignals.generator_state.connect(_on_generator_state)

func _on_generator_state(state: bool) -> void:
	light_1.visible = not state
	light_2.visible = not state
