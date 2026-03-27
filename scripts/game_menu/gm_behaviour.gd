extends Node

@onready var menu: Control = $Menu
@onready var game_over: Control = $GameOver

@onready var label: Label = $GameOver/Label

@onready var menu_open : bool = false

@onready var node: Control = $Node

func _ready() -> void:
	AllSignals.game_over.connect(_on_game_over)
	game_over.visible = false
	menu.visible = false
	node.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		menu_open = not menu_open
		if not menu_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		menu.visible = menu_open
		node.visible = menu_open
		
func _on_game_over(type: GameOverType.Type) -> void:
	menu.visible = false
	node.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_over.visible = true
	if type == GameOverType.Type.Win:
		label.text = "Win"
	else:
		label.text = "Lose"


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
