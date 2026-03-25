extends CharacterBody3D

@export var animation : AnimationPlayer
@export var player : Node3D

@onready var temperature : float = -273.15
var temperature_delta : float = 1.0
var temperature_timer : float = 0.0
var temperature_time : float = 1.0
var temperature_unfreeze : float = -200.0

var is_generator_off : bool = false
var is_game_over : bool = false

enum monster_states {
	FROZEN,
	UNFROZEN,
}

func _ready() -> void:
	add_to_group("entity")
	AllSignals.jumpscare.connect(_on_jumpscare_signal)
	AllSignals.generator_state.connect(_on_shutdown)

func _on_shutdown(state: bool) -> void:
	print("Generator state: " + str(state))
	is_generator_off = state

func _on_jumpscare_signal(_player : Node3D) -> void:
	is_game_over = true

func _idle() -> void:
	if animation.is_playing(): return
	animation.play("idle")

func _on_interact() -> void:
	AllSignals.emit_signal("examine", true)

func _temperature(delta: float) -> void:
	if temperature >= temperature_unfreeze:
		if player:
			AllSignals.emit_signal("jumpscare", player)
		else:
			push_error("Entity temperature reached unfreeze but 'player' is not assigned in e_behaviour.gd")
	
	temperature_timer += delta
	print(temperature)
	
	if temperature_timer >= temperature_time:
		temperature += temperature_delta
		temperature_timer = 0.0
		AllSignals.emit_signal("temperature", temperature)

func _process(delta: float) -> void:
	if is_game_over: return
	
	_idle()
	
	if is_generator_off:
		_temperature(delta)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
