extends Node

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		var mode = DisplayServer.window_get_mode()
		
		if mode == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_exit_pressed() -> void:
	get_tree().quit()
