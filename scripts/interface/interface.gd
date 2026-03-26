extends Node

@onready var fluid: Label = $Time


func _ready() -> void:
	AllSignals.timer.connect(_on_timer)

func _on_timer(time: int) -> void:
	var hours: int = time / 60
	
	fluid.text = str(hours) + "AM"
