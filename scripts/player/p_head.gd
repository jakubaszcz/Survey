extends Node3D

@onready var camera: Camera3D = $Camera3D

@export var ray : RayCast3D

@export var hand : Node

var hand_item : Item = null
var hand_item_type : ItemType.type = ItemType.type.Item

var sensivity : float = 0.002
var camera_rotation_x : float = 0.0

var jumpscare : bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	AllSignals.jumpscare.connect(_on_jumpscare)

func _on_jumpscare(player : Node3D) -> void:
	jumpscare = true

func _input(event) -> void:
	_mouse_movement(event)
	
func _mouse_movement(event):
	if not jumpscare:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			get_parent().rotate_y(-event.relative.x * sensivity)
		
			camera_rotation_x -= event.relative.y * sensivity
			camera_rotation_x = clamp(camera_rotation_x, deg_to_rad(-89.0), deg_to_rad(89.0))
			camera.rotation.x = camera_rotation_x
	else:
		camera.rotation.x = deg_to_rad(0)

func _physics_process(delta) -> void:
	if ray and ray.is_colliding():
		var hit: Object = ray.get_collider()
		if hit.is_in_group("entity"):
			if Input.is_action_pressed("interact") and not jumpscare:
				if hand_item_type == ItemType.type.Syringe:
					hit._on_interact()
					hand_item.queue_free()
					hand_item_type = ItemType.type.Item
				if hand_item_type == ItemType.type.Pill:
					hit._on_pill()
					hand_item.queue_free()
					hand_item_type = ItemType.type.Item
		if hit.is_in_group("interactable"):
			if Input.is_action_pressed("interact") and not jumpscare:
				hit._on_interact(delta)
			if Input.is_action_just_released("interact") and not jumpscare:
				hit._on_release()
		if hit is Item:
			if Input.is_action_pressed("interact") and not jumpscare:
				if hand_item:
					hand_item.queue_free()
				hand_item = hit._hold(hand)
				hand_item_type = hand_item.item_type
			
