extends CharacterBody3D

@export var examine_light: StandardMaterial3D

func _ready() -> void:
	AllSignals.examine.connect(_on_examine_light)

func _on_examine_light(type: ExamineType.type) -> void:
	match type:
		ExamineType.type.Nothing:
			examine_light.albedo_color = Color.YELLOW
		ExamineType.type.Temperature_lack:
			examine_light.albedo_color = Color.BLUE
		ExamineType.type.Fail:
			examine_light.albedo_color = Color.BLACK
