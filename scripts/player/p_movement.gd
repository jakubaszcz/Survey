extends CharacterBody3D

@onready var current_speed : float = 0.0
@onready var walk_speed : float = 5.0

@export var spot_light_3d: SpotLight3D
@onready var flashlight_toggle: bool = false

@export var monster : CharacterBody3D

@onready var footstep: AudioStreamPlayer3D = $Footstep

var jumscare : bool = false

func _ready() -> void:
	AllSignals.jumpscare.connect(_on_jumpscare)
	spot_light_3d.visible = flashlight_toggle


func _on_jumpscare(player : Node3D) -> void:
	jumscare = true

func _on_flashlight(state: bool) -> void:
	spot_light_3d.visible = state

func _input(event) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_J:
				print("You pressed J You dumbass")
				AllSignals.emit_signal("prepare_jumpscare", self)

func _movement_process(delta) -> void:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = transform.basis * Vector3(input.x, 0, input.y)
	
	current_speed = walk_speed
	
	if input != Vector2.ZERO:
		if not footstep.playing:
			footstep.play()
	else:
		if footstep.playing:
			footstep.stop()
	
	velocity = direction * current_speed

func _physics_process(delta) -> void:
	if jumscare: return
	_movement_process(delta)
	
	if Input.is_action_just_pressed("flashlight"):
		print("Flashlight toggled")
		flashlight_toggle = not flashlight_toggle
		_on_flashlight(flashlight_toggle)
	
	move_and_slide()
