extends CharacterBody3D

@export var gen_sound : AudioStreamPlayer3D

var shutdown_prob_max : int = 100
var shutdown_prob_min : int = 5
var shutdown_timer : float = 0.0
var shutdown_time : float = 1.0

enum States {
	ACTIVE,
	UNACTIVE
}

var state : States = States.ACTIVE

func _ready() -> void:
	add_to_group("interactable")

func _on_interact() -> void:
	if state == States.ACTIVE: return

func _physics_process(delta) -> void:
	if state == States.UNACTIVE: return
	
	if not gen_sound.is_playing():
		gen_sound.play()
	
	shutdown_timer += delta
	if shutdown_timer >= shutdown_time:
		var random: int = randi_range(shutdown_prob_min, shutdown_prob_max)
		if random <= 100:
			gen_sound.stop()
			state = States.UNACTIVE
			AllSignals.emit_signal("generator_state", true)
			print("Gen shutdown")
			
