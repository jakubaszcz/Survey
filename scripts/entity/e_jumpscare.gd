extends Node3D

@export var animation : AnimationPlayer
@export var distance : float = 4.6

func _ready() -> void:
	AllSignals.jumpscare.connect(_on_jumpscare)

func _on_jumpscare(player : Node3D) -> void:
	if not player:
		return

	var camera: Camera3D = player.get_viewport().get_camera_3d()
	
	var target = camera if camera else player

	self.get_parent().remove_child(self)
	target.add_child(self)

	transform.origin = Vector3(0, -3.5, -distance) 

	await get_tree().create_timer(1.0).timeout
	AllSignals.emit_signal("game_over", GameOverType.Type.Lose)
