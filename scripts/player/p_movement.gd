extends CharacterBody3D

@onready var current_speed : float = 0.0
@onready var walk_speed : float = 10.0
@onready var sprint_speed : float = 20.0

func _movement_process(delta) -> void:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = transform.basis * Vector3(input.x, 0, input.y)
	
	current_speed = walk_speed
	
	velocity = direction * current_speed

func _physics_process(delta) -> void:
	_movement_process(delta)
	
	move_and_slide()
