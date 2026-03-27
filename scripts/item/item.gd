extends CharacterBody3D

class_name Item

@export var grab_sound : AudioStreamPlayer3D

var item_type : ItemType.type = ItemType.type.Item

func _hold(new_parent: Node3D) -> Item:
	print("Holding item" + str(item_type))
	grab_sound.play()
	var copy : Item = self.duplicate()
	new_parent.add_child(copy)
	copy.position = new_parent.position
	copy.rotation = Vector3.ZERO
	return copy
