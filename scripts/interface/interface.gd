extends Node

@onready var fluid: Label = $Time/Time

@onready var game_type : GameType.Type = GameType.Type.Tutorial

@onready var tutorial: Control = $Tutorial

@onready var dialogue: Label = $Control/Dialogue

func _ready() -> void:
	AllSignals.timer.connect(_on_timer)
	AllSignals.end_tutorial.connect(_on_end_tutorial)
	AllSignals.send_dialogue.connect(_on_send_dialogue)
	fluid.visible = false

func _on_send_dialogue(value: String) -> void:
	dialogue.text = value

func _on_end_tutorial() -> void:
	fluid.visible = true
	tutorial.visible = false
	dialogue.visible = false

func _on_timer(time: int) -> void:
	var hours: int = time / 60
	
	fluid.text = str(hours) + "AM"
