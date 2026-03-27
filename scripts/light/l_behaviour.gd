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
var flicker_interval: float = 0.12

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

func _process(delta: float) -> void:
	if not tutorial_finished:
		return

	if generator_off:
		return

	flicker_timer += delta

	if flicker_timer >= flicker_interval:
		flicker_timer = 0.0
		_flicker_lights()

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

	_set_visible(not generator_off)

func _flicker_lights() -> void:
	for i in range(lights.size()):
		var light := lights[i]
		if light == null:
			continue

		light.light_energy = randf_range(0.7, 1.25)

		if randf() < 0.08:
			light.visible = false
		else:
			light.visible = true

		if randf() < 0.18:
			_play_flicker_sound(i)

func _play_flicker_sound(index: int) -> void:
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
