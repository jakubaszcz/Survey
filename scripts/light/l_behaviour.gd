extends Node

@export var light_1: OmniLight3D
@export var light_2: OmniLight3D
@export var light_3: OmniLight3D
@export var light_4: OmniLight3D
@export var light_5: OmniLight3D

@onready var alarm : bool = false

func _ready() -> void:
	AllSignals.generator_state.connect(_on_generator_state)
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)
	AllSignals.end_tutorial.connect(_on_end_tutorial)
	light_1.light_energy = 5
	light_2.light_energy = 5
	light_3.light_energy = 5
	light_4.light_energy = 5
	light_5.light_energy = 5

func _on_end_tutorial() -> void:
	light_1.light_energy = 1
	light_2.light_energy = 1
	light_3.light_energy = 1
	light_4.light_energy = 1
	light_5.light_energy = 1

func _on_internal_bleeding(value: bool) -> void:
	alarm = value
	
	if alarm:
		light_1.light_color = Color.RED
		light_2.light_color = Color.RED
		light_3.light_color = Color.RED
		light_4.light_color = Color.RED
	else:
		light_1.light_color = Color.WHITE
		light_2.light_color = Color.WHITE
		light_3.light_color = Color.WHITE
		light_4.light_color = Color.WHITE

func _on_generator_state(state: bool) -> void:
	light_1.visible = not state
	light_2.visible = not state
	light_3.visible = not state
	light_4.visible = not state
	light_5.visible = not state
