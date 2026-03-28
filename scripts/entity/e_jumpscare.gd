extends Node3D

@export var animation : AnimationPlayer
@export var distance : float = 4.6

@onready var disapear: AudioStreamPlayer3D = $"../Disapear"

@onready var spot_light_3d: SpotLight3D = $SpotLight3D

func _ready() -> void:
	AllSignals.prepare_jumpscare.connect(_on_prepare_jumpscare)
	AllSignals.jumpscare.connect(_on_jumpscare)
	spot_light_3d.visible = false


func _on_prepare_jumpscare(player: Node3D) -> void:
	if not player:
		return

	var steps: Array[Callable] = []

	var random := randi_range(0, 2)

	match random:
		0:
			steps.append(func(): await _disappear())
			steps.append(func(): await _wait(randf_range(2.5, 6.0)))
		1:
			steps.append(func(): await _power_off())
			steps.append(func(): await _wait(randf_range(1.5, 4.0)))
		2: pass


	steps.append(func(): await _on_jumpscare(player))

	for step in steps:
		await step.call()

func _power_off() -> void:
	AllSignals.emit_signal("generator_state", true)

func _disappear() -> void:
	disapear.play()
	get_parent().visible = false

func _wait(time: float) -> void:
	await get_tree().create_timer(time).timeout

func _on_jumpscare(player : Node3D) -> void:
	if not player:
		return
	get_parent().visible = true
	spot_light_3d.visible = true

	var camera: Camera3D = player.get_viewport().get_camera_3d()
	
	var target = camera if camera else player

	self.get_parent().remove_child(self)
	target.add_child(self)

	transform.origin = Vector3(0, -3.5, -distance) 

	await get_tree().create_timer(1.0).timeout
	AllSignals.emit_signal("game_over", GameOverType.Type.Lose)
