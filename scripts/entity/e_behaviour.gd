extends CharacterBody3D

@export var animation : AnimationPlayer

enum monster_states {
	FROZEN,
	UNFROZEN,
}

func _idle() -> void:
	if animation.is_playing(): return
	animation.play("idle")

func _process(delta: float) -> void:
	_idle()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
