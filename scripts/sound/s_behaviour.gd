extends Node

@export var power_off_sound : AudioStreamPlayer3D
@export var alarm_sound : AudioStreamPlayer3D

@onready var alarm : bool = false

func _ready() -> void:
	power_off_sound.play()
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)

func _on_internal_bleeding(value: bool) -> void:
	alarm = value
	if alarm_sound.is_playing():
		alarm_sound.stop()
	if power_off_sound.is_playing():
		power_off_sound.stop()
		
	if not value:
		power_off_sound.play()
	else:
		alarm_sound.play()
