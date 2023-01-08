extends Pickable
class_name SlimeEgg

func _on_pickable_changed(pickable: bool):
	$Egg.frame = int(pickable)

func _ready():
	connect("is_pickable_changed", self, "_on_pickable_changed")
	
	$Egg.frame = 0
