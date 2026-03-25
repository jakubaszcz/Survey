extends CharacterBody3D

@export var animation : AnimationPlayer

enum monster_states {
	FROZEN,
	UNFROZEN,
}

func _ready() -> void:
	add_to_group("entity")

func _idle() -> void:
	if animation.is_playing(): return
	animation.play("idle")

func _on_interact() -> void:
	print("interact with syringe")

func _process(delta: float) -> void:
	_idle()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
