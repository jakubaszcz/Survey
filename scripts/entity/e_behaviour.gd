extends CharacterBody3D

@export var animation : AnimationPlayer
@export var player : Node3D

@onready var temperature : float = -273.15
var temperature_max : float = -273.15
var temperature_min : float = -200.0	
var temperature_delta : float = 1.0
var temperature_timer : float = 0.0
var generator_off_temperature_time : float = 0.8
var generator_on_temperature_time : float = 1.8
var temperature_unfreeze : float = -200.0

var fail_prob_max : int = 100
var fail_prob_min : int = 5
var fail_prob : int = 15

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
	var rand: int = randi_range(fail_prob_min, fail_prob_max)
	var type : ExamineType.type = ExamineType.type.Nothing
	
	if rand <= fail_prob:
		type = ExamineType.type.Fail
	else:
		var diff_temp = abs(temperature - temperature_max) / abs(temperature_max)
		if diff_temp > 0.1:
			type = ExamineType.type.Temperature_lack
		else:
			type = ExamineType.type.Nothing
	
	
	AllSignals.emit_signal("examine", type)

func _temperature(delta: float) -> void:
	if temperature >= temperature_unfreeze:
		if player:
			AllSignals.emit_signal("jumpscare", player)
		else:
			push_error("Entity temperature reached unfreeze but 'player' is not assigned in e_behaviour.gd")
	
	temperature_timer += delta
	print(temperature)
	
	var time: float = generator_off_temperature_time if is_generator_off else generator_on_temperature_time
	
	if temperature_timer >= time:
		temperature += temperature_delta
		temperature_timer = 0.0
		AllSignals.emit_signal("temperature", temperature)

func _process(delta: float) -> void:
	if is_game_over: return
	
	_idle()
	
	_temperature(delta)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
