extends CharacterBody3D

@export var gen_sound : AudioStreamPlayer3D

var shutdown_prob_max : int = 100
var shutdown_prob_min : int = 5
var shutdown_prob : int = 15
var shutdown_timer : float = 0.0
var shutdown_time : float = 10.0

var interact_time : float = 0.0
var max_interact_time : float = 3.0
var interacting : bool = false

enum States {
	ACTIVE,
	UNACTIVE
}

@onready var state : States = States.ACTIVE

@onready var game_type : GameType.Type = GameType.Type.Tutorial

func _ready() -> void:
	add_to_group("interactable")
	AllSignals.end_tutorial.connect(_on_end_tutorial)

func _on_end_tutorial() -> void:
	game_type = GameType.Type.Game

func _on_interact(delta) -> void:

	if game_type == GameType.Type.Tutorial:
		interact_time += delta
		if interact_time >= max_interact_time:
			AllSignals.emit_signal("step_complete", TutorialCondition.Condition.PowerBack)
			AllSignals.emit_signal("generator_state", false)
			interact_time = 0.0
			return

	interacting = true
	if state == States.UNACTIVE:
		interact_time += delta
		if interact_time >= max_interact_time:
			state = States.ACTIVE
			interact_time = 0.0
			AllSignals.emit_signal("generator_state", false)

func _on_release() -> void:
	pass

func _game(delta: float) -> void:
	if not interacting:
		interact_time = 0.0
	interacting = false
	
	if state == States.UNACTIVE: return
	
	if not gen_sound.is_playing():
		gen_sound.play()
	
	shutdown_timer += delta
	if shutdown_timer >= shutdown_time:
		shutdown_timer = 0.0
		var random: int = randi_range(shutdown_prob_min, shutdown_prob_max)
		if random <= shutdown_prob:
			gen_sound.stop()
			state = States.UNACTIVE
			AllSignals.emit_signal("generator_state", true)


func _physics_process(delta) -> void:
	if game_type == GameType.Type.Game: _game(delta)
