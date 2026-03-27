extends Node

@onready var fluid: Label = $Time

@onready var game_type : GameType.Type = GameType.Type.Tutorial

@onready var tutorial: Control = $Tutorial

func _ready() -> void:
	AllSignals.timer.connect(_on_timer)
	AllSignals.end_tutorial.connect(_on_end_tutorial)

func _on_end_tutorial() -> void:
	tutorial.visible = false

func _on_timer(time: int) -> void:
	var hours: int = time / 60
	
	fluid.text = str(hours) + "AM"
