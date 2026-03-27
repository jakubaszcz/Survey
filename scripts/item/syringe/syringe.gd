extends Item

@onready var game_type : GameType.Type = GameType.Type.Tutorial

func _ready() -> void:
	item_type = ItemType.type.Syringe
	AllSignals.end_tutorial.connect(_on_end_tutorial)

func _on_end_tutorial() -> void:
	game_type = GameType.Type.Game

func _hold(_new_parent: Node3D) -> Item:
	if game_type == GameType.Type.Tutorial:
		AllSignals.emit_signal("step_complete", TutorialCondition.Condition.DiscoverSyringe)
	return super._hold(_new_parent)
