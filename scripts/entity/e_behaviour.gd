extends CharacterBody3D

@export var animation : AnimationPlayer
@export var player : Node3D


@onready var syringe : int = 0
var syringe_max : int = 100
var syringe_min : int = 0
var syring_prob : int = 10
var is_internal_bleeding = false

@onready var temperature : float = -110
var temperature_max : float = -110
var temperature_min : float = 10
var temperature_delta : float = 0.6
var internal_bleeding_temperature_delta : float = 1.2
var temperature_timer : float = 0.0
var generator_off_temperature_time : float = 1.0
var generator_on_temperature_time : float = 1.8
var temperature_unfreeze : float = 10

var fluid : int = 100
var fluid_timer : float = 0.0
var fluid_time : float = 5.0
var fluid_delta : int = 1
var internal_bleeding_fluid_time : float = 3.0

var fail_prob_max : int = 100
var fail_prob_min : int = 5
var fail_prob : int = 15

var is_generator_off : bool = false
var is_game_over : bool = false

enum monster_states {
	FROZEN,
	UNFROZEN,
}
@onready var has_malus : bool = false
@onready var temperature_error : bool = false
@onready var fluid_error : bool = false

var malus_timer : float = 0.0
var malus_during_timer : float = 0.0
var malus_duration : float = 10.0
var malus_time : float = 1.5
var malus_temperature : float = 0.8
var malus_fluid : int = 1

func _ready() -> void:
	add_to_group("entity")
	AllSignals.jumpscare.connect(_on_jumpscare_signal)
	AllSignals.generator_state.connect(_on_shutdown)
	AllSignals.rise_temperature.connect(_on_temperature)
	AllSignals.rise_fluid.connect(_on_fluid)
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)

func _on_fluid(new_fluid: int) -> void:
	if fluid_error:
		AllSignals.emit_signal("action_error")
		return
	
	fluid += new_fluid
	
	if fluid > 100:
		fluid = 100
		fluid_error = true
		has_malus = true
		AllSignals.emit_signal("action_error")
		return
	
	AllSignals.emit_signal("action_success")
	AllSignals.emit_signal("fluid", fluid)

func _on_internal_bleeding(state: bool) -> void:
	syringe = 0
	is_internal_bleeding = state

func _on_temperature(new_temperature: float) -> void:
	if temperature_error:
		AllSignals.emit_signal("action_error")
		return
		
	temperature -= new_temperature
	
	if temperature <= temperature_max:
		temperature = temperature_max
		temperature_error = true
		has_malus = true
		AllSignals.emit_signal("action_error")
		return
	
	AllSignals.emit_signal("temperature", temperature)
	AllSignals.emit_signal("action_success")
	print("Temperature: " + str(temperature))
	return

func _on_shutdown(state: bool) -> void:
	print("Generator state: " + str(state))
	is_generator_off = state

func _on_jumpscare_signal(_player : Node3D) -> void:
	is_game_over = true

func _idle() -> void:
	if animation.is_playing(): return
	animation.play("idle")

func _on_pill() -> void:
	if is_internal_bleeding: 
		AllSignals.emit_signal("internal_bleeding", false)
	else:
		has_malus = true

func _malus(delta: float) -> void:
	malus_timer += delta
	malus_during_timer += delta
	
	if malus_during_timer >= malus_duration:
		malus_during_timer = 0.0
		has_malus = false
		temperature_error = false
		fluid_error = false
		return
	
	if malus_timer >= malus_time:
		malus_timer = 0.0
		temperature += malus_temperature
		fluid -= malus_fluid

func _on_interact() -> void:
	syringe += 1
	
	var syringe_rand: int = randi_range(syringe_min, syringe_max)
	var rand: int = randi_range(fail_prob_min, fail_prob_max)
	var type: ExamineType.type = ExamineType.type.Nothing
	
	if rand <= fail_prob:
		type = ExamineType.type.Fail
	else:
		var diff_temp: float = abs(temperature - temperature_max) / abs(temperature_max)
		var diff_fluid: float = abs(fluid - 100.0) / 100.0
		
		if syringe_rand <= syring_prob + (2 * syringe):
			AllSignals.emit_signal("internal_bleeding", true)
		
		if diff_temp > 0.1:
			type = ExamineType.type.Temperature_lack
		elif diff_fluid > 0.2:
			type = ExamineType.type.Fluid_lack
		else:
			type = ExamineType.type.Nothing
	
	AllSignals.emit_signal("examine", type)

func _temperature(delta: float) -> void:
	if temperature >= temperature_unfreeze:
		if player:
			AllSignals.emit_signal("jumpscare", player)
	
	temperature_timer += delta
	
	var time: float = generator_off_temperature_time if is_generator_off else generator_on_temperature_time
	var value: float = internal_bleeding_temperature_delta if is_internal_bleeding else temperature_delta
	
	if temperature_timer >= time:
		var fluid_ratio = clamp(fluid / 100.0, 0.0, 1.0)
		var multiplier = lerp(2.0, 1.0, fluid_ratio)
		
		temperature += value * multiplier
		temperature_timer = 0.0
		
		AllSignals.emit_signal("temperature", temperature)

func _fluid(delta: float) -> void:
	fluid_timer += delta
	
	var time: float = internal_bleeding_fluid_time if is_internal_bleeding else fluid_time
	
	if fluid_timer >= time:
		fluid_timer = 0.0
		fluid -= fluid_delta
		AllSignals.emit_signal("fluid", fluid)

func _process(delta: float) -> void:
	if is_game_over: return
	
	_idle()
	
	_temperature(delta)
	_fluid(delta)
	
	if has_malus:
		_malus(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
