extends Node

var timer: float = 0.0
var elapsed_time: int = 0
var max_time: int = 360

var game_over: bool = false

func _ready() -> void:
	AllSignals.game_over.connect(_on_game_over)

func _on_game_over(type: GameOverType.Type) -> void:
	print("Game Over")
	game_over = true

func _process(delta: float) -> void:
	if game_over:
		return

	timer += delta

	while timer >= 1.0:
		timer -= 1.0
		elapsed_time += 1
		AllSignals.timer.emit(elapsed_time)

		if elapsed_time >= max_time:
			game_over = true
			AllSignals.game_over.emit(GameOverType.Type.Win)
			return
