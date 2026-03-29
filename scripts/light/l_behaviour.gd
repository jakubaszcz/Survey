extends Node

@export var light_1: OmniLight3D
@export var light_2: OmniLight3D
@export var light_3: OmniLight3D
@export var light_4: OmniLight3D
@export var light_5: OmniLight3D

@export var sound_flicker_light_1: AudioStreamPlayer3D
@export var sound_flicker_light_2: AudioStreamPlayer3D
@export var sound_flicker_light_3: AudioStreamPlayer3D
@export var sound_flicker_light_4: AudioStreamPlayer3D
@export var sound_flicker_light_5: AudioStreamPlayer3D

@export var sound_exploding_bulb_1: AudioStreamPlayer3D
@export var sound_exploding_bulb_2: AudioStreamPlayer3D
@export var sound_exploding_bulb_3: AudioStreamPlayer3D
@export var sound_exploding_bulb_4: AudioStreamPlayer3D
@export var sound_exploding_bulb_5: AudioStreamPlayer3D

@onready var alarm: bool = false
@onready var tutorial_finished: bool = false
@onready var generator_off: bool = false

var flicker_timer: float = 0.0
var next_flicker_delay: float = 0.0
var flicker_duration: float = 0.0
var is_flickering: bool = false
var current_flicker_index: int = -1

var lights: Array[OmniLight3D] = []
var flicker_sounds: Array[AudioStreamPlayer3D] = []
var explode_sounds: Array[AudioStreamPlayer3D] = []

func _ready() -> void:
	lights = [light_1, light_2, light_3, light_4, light_5]

	flicker_sounds = [
		sound_flicker_light_1,
		sound_flicker_light_2,
		sound_flicker_light_3,
		sound_flicker_light_4,
		sound_flicker_light_5
	]

	explode_sounds = [
		sound_exploding_bulb_1,
		sound_exploding_bulb_2,
		sound_exploding_bulb_3,
		sound_exploding_bulb_4,
		sound_exploding_bulb_5
	]

	AllSignals.generator_state.connect(_on_generator_state)
	AllSignals.internal_bleeding.connect(_on_internal_bleeding)
	AllSignals.end_tutorial.connect(_on_end_tutorial)

	_set_energy(5.0)
	_set_visible(true)
	_update_light_color()
	_reset_next_flicker_delay()

func _process(delta: float) -> void:
	if not tutorial_finished:
		return

	if generator_off:
		return

	flicker_timer += delta

	if is_flickering:
		_handle_active_flicker()
		flicker_duration -= delta

		if flicker_duration <= 0.0:
			_stop_flicker()
	else:
		if flicker_timer >= next_flicker_delay:
			_start_random_flicker()

func _on_end_tutorial() -> void:
	tutorial_finished = true
	_set_energy(0.2)

func _on_internal_bleeding(value: bool) -> void:
	alarm = value
	_update_light_color()

func _on_generator_state(state: bool) -> void:
	var was_generator_off: bool = generator_off
	generator_off = state

	if generator_off and not was_generator_off:
		_play_power_cut_effect()
		_stop_flicker()
		_stop_all_flicker_sounds()

	_set_visible(not generator_off)

	if not generator_off and was_generator_off:
		_reset_next_flicker_delay()
		_restore_all_lights()

func _start_random_flicker() -> void:
	if lights.is_empty():
		return

	current_flicker_index = randi_range(0, lights.size() - 1)
	is_flickering = true
	flicker_timer = 0.0
	flicker_duration = randf_range(0.25, 0.8)

	_play_flicker_sound(current_flicker_index)

func _handle_active_flicker() -> void:
	if current_flicker_index < 0 or current_flicker_index >= lights.size():
		return

	var light := lights[current_flicker_index]
	if light == null:
		return

	light.visible = randf() > 0.35
	light.light_energy = randf_range(0.05, 0.35)

func _stop_flicker() -> void:
	is_flickering = false
	current_flicker_index = -1
	flicker_timer = 0.0
	_reset_next_flicker_delay()
	_restore_all_lights()

func _reset_next_flicker_delay() -> void:
	next_flicker_delay = randf_range(2.5, 6.0)

func _restore_all_lights() -> void:
	for light in lights:
		if light == null:
			continue

		light.visible = true
		light.light_energy = 0.2

	_update_light_color()

func _play_flicker_sound(index: int) -> void:
	if generator_off:
		return

	if index < 0 or index >= flicker_sounds.size():
		return

	var sound := flicker_sounds[index]
	if sound == null:
		return

	if sound.playing:
		return

	sound.pitch_scale = randf_range(0.92, 1.08)
	sound.volume_db = randf_range(-8.0, -2.0)
	sound.play()

func _stop_all_flicker_sounds() -> void:
	for sound in flicker_sounds:
		if sound != null and sound.playing:
			sound.stop()

func _play_power_cut_effect() -> void:
	for i in range(lights.size()):
		var light := lights[i]
		if light == null:
			continue

		light.light_energy = randf_range(1.5, 2.5)
		_play_explode_sound(i)

func _play_explode_sound(index: int) -> void:
	if index < 0 or index >= explode_sounds.size():
		return

	var sound := explode_sounds[index]
	if sound == null:
		return

	sound.pitch_scale = randf_range(0.95, 1.05)
	sound.volume_db = randf_range(-4.0, 0.0)
	sound.play()

func _update_light_color() -> void:
	if alarm:
		_set_color(Color.RED)
	else:
		_set_color(Color.WHITE)

func _set_energy(value: float) -> void:
	for light in lights:
		if light != null:
			light.light_energy = value

func _set_color(value: Color) -> void:
	for light in lights:
		if light != null:
			light.light_color = value

func _set_visible(value: bool) -> void:
	for light in lights:
		if light != null:
			light.visible = value
