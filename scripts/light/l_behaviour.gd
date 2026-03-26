extends Node

@export var light_1: OmniLight3D
@export var light_2: OmniLight3D

@onready var alarm : bool = false

func _ready() -> void:
	AllSignals.generator_state.connect(_on_generator_state)
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)

func _on_internal_bleeding(value: bool) -> void:
	alarm = value
	
	if alarm:
		light_1.light_color = Color.RED
		light_2.light_color = Color.RED
	else:
		light_1.light_color = Color.WHITE
		light_2.light_color = Color.WHITE

func _on_generator_state(state: bool) -> void:
	light_1.visible = not state
	light_2.visible = not state
