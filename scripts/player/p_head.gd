extends Node3D

@onready var camera: Camera3D = $Camera3D

var sensivity : float = 0.002
var camera_rotation_x : float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
	_mouse_movement(event)
	
func _mouse_movement(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		get_parent().rotate_y(-event.relative.x * sensivity)
		
		camera_rotation_x -= event.relative.y * sensivity
		camera_rotation_x = clamp(camera_rotation_x, deg_to_rad(-89.0), deg_to_rad(89.0))
		camera.rotation.x = camera_rotation_x
