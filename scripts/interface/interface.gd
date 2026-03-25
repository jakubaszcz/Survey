extends Node

@onready var fluid: Label = $Fluid
@onready var temp: Label = $Temp
@export var bleeding: Label


func _ready() -> void:
	AllSignals.temperature.connect(_on_temperature)
	AllSignals.fluid.connect(_on_fluid)
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)

func _on_internal_bleeding(value: bool) -> void:
	bleeding.text = "Internal bleeding : " + str(value)

func _on_fluid(value: float) -> void:
	fluid.text = "Fluid : %.2f" % value

func _on_temperature(value: float) -> void:
	temp.text = "Temp : %.2f" % value
