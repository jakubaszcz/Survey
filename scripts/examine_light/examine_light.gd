extends CharacterBody3D

@export var examine_light: StandardMaterial3D

var examine_type : ExamineType.type = ExamineType.type.Nothing

func _ready() -> void:
	add_to_group("indicator")
	AllSignals.examine.connect(_on_examine_light)

func _on_indicate() -> String:
	match examine_type:
		ExamineType.type.Nothing:
			return "Nothing"
		ExamineType.type.Temperature_lack:
			return "Temperature lack"
		ExamineType.type.Fluid_lack:
			return "Fluid lack"
		ExamineType.type.Fail:
			return "Fail"
	return ""

func _on_examine_light(type: ExamineType.type) -> void:
	match type:
		ExamineType.type.Nothing:
			examine_light.albedo_color = Color.YELLOW
			examine_type = ExamineType.type.Nothing
		ExamineType.type.Temperature_lack:
			examine_light.albedo_color = Color.BLUE
			examine_type = ExamineType.type.Temperature_lack
		ExamineType.type.Fluid_lack:
			examine_light.albedo_color = Color.RED
			examine_type = ExamineType.type.Fluid_lack
		ExamineType.type.Fail:
			examine_light.albedo_color = Color.BLACK
			examine_type = ExamineType.type.Fail
