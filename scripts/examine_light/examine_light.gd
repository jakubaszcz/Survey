extends CharacterBody3D

@export var examine_light: StandardMaterial3D
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

func _ready() -> void:
	AllSignals.examine.connect(_on_examine_light)
	omni_light_3d.visible = false

func _on_examine_light(type: ExamineType.type) -> void:
	omni_light_3d.visible = true
	match type:
		ExamineType.type.Nothing:
			omni_light_3d.light_color = Color.YELLOW
			examine_light.albedo_color = Color.YELLOW
		ExamineType.type.Temperature_lack:
			omni_light_3d.light_color = Color.BLUE
			examine_light.albedo_color = Color.BLUE
		ExamineType.type.Fluid_lack:
			omni_light_3d.light_color = Color.RED
			examine_light.albedo_color = Color.RED
		ExamineType.type.Fail:
			omni_light_3d.light_color = Color.BLACK
			examine_light.albedo_color = Color.BLACK
