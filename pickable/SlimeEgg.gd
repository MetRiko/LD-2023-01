extends Pickable
class_name SlimeEgg

const slime_tscn := preload("res://slimes/Slime.tscn")

var cracked := false

func set_ready_to_break():
	if not cracked:
		$CrackParticles.emitting = true
		cracked = true
		$Egg.visible = false
		set_pickable(false)
		$Timer.start(3)

func _crack_egg():
	var slime = slime_tscn.instance()
	Game.add_slime(slime)
	queue_free()
	slime.global_position = position
	slime.set_color($Inside.modulate)
	slime.change_size(0.2)

func _on_pickable_changed(pickable: bool):
	$Egg.frame = int(pickable)

func _ready():
	connect("is_pickable_changed", self, "_on_pickable_changed")
	$Timer.connect("timeout", self, "_crack_egg")
	
	$Inside.modulate = Color.from_hsv(randf(), 0.8, 0.9)
	$Egg.frame = 0
