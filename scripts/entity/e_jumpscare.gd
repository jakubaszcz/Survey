extends Node3D

@export var animation : AnimationPlayer
@export var distance : float = 3.8

func _ready() -> void:
	AllSignals.jumpscare.connect(_on_jumpscare)

func _on_jumpscare(player : Node3D) -> void:
	if not player:
		return
	var forward: Vector3 = -player.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	forward.y -= 0.5
	forward.z -= 0.6
	global_transform.origin = player.global_transform.origin + forward * distance
	
	var target_pos: Vector3 = player.global_transform.origin
	target_pos.y = global_transform.origin.y
	look_at(target_pos, Vector3.UP)
	rotate_y(PI)
	
	await get_tree().create_timer(1.0).timeout
	AllSignals.emit_signal("game_over", GameOverType.Type.Lose)
