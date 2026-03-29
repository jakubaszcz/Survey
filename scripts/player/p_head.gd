extends Node3D

@onready var camera: Camera3D = $Camera3D

@export var ray : RayCast3D

@export var hand : Node

var hand_item : Item = null
var hand_item_type : ItemType.type = ItemType.type.Item

var sensivity : float = 0.002
var camera_rotation_x : float = 0.0

var jumpscare : bool = false

var indicate : bool = false

var shake_intensity : float = 0.3
var shake_tween : Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	AllSignals.jumpscare.connect(_on_jumpscare)

func _on_jumpscare(_player : Node3D) -> void:
	jumpscare = true
	
	if shake_tween:
		shake_tween.kill() 
	
	shake_tween = create_tween()
	for i in range(10):
		var random_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
		shake_tween.tween_property(camera, "h_offset", random_offset.x, 0.05)
		shake_tween.tween_property(camera, "v_offset", random_offset.y, 0.05)
	
	shake_tween.tween_property(camera, "h_offset", 0.0, 0.1)
	shake_tween.tween_property(camera, "v_offset", 0.0, 0.1)
	

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

func _physics_process(delta: float) -> void:
	if not ray or not ray.is_colliding():
		_clear_indication()
		indicate = false
		return

	var hit: Object = ray.get_collider()
	var indication_text: String = ""

	# Indicator
	if hit.is_in_group("indicator"):
		if not indicate:
			indication_text = hit._on_indicate()
			indicate = true
	else:
		indicate = false

	if hit.is_in_group("entity"):
		_handle_entity_interaction(hit)

	elif hit.is_in_group("interactable"):
		indication_text = "Hold E to Interact"
		_handle_interactable_interaction(hit, delta)

	# Item interaction
	elif hit is Item:
		indication_text = "Press E to Interact"
		_handle_item_interaction(hit)

	# Final indication update
	AllSignals.emit_signal("indicate", indication_text)

func _handle_entity_interaction(hit: Object) -> void:
	if jumpscare:
		return
	
	if not Input.is_action_just_pressed("interact"):
		return

	if hand_item_type == ItemType.type.Syringe:
		hit._on_interact()
		if hand_item:
			hand_item.queue_free()
		hand_item_type = ItemType.type.Item

	elif hand_item_type == ItemType.type.Pill:
		hit._on_pill()
		if hand_item:
			hand_item.queue_free()
		hand_item_type = ItemType.type.Item

func _handle_interactable_interaction(hit: Object, delta: float) -> void:
	if jumpscare:
		return

	if Input.is_action_pressed("interact"):
		hit._on_interact(delta)

	if Input.is_action_just_released("interact"):
		hit._on_release()

func _handle_item_interaction(hit: Item) -> void:
	if jumpscare:
		return

	if not Input.is_action_just_pressed("interact"):
		return

	if hand_item:
		hand_item.queue_free()

	hand_item = hit._hold(hand)
	hand_item_type = hand_item.item_type

func _clear_indication() -> void:
	AllSignals.emit_signal("indicate", "")
