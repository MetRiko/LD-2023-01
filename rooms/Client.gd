extends KinematicBody2D

const jar = preload("res://pickable/SlimeJar.tscn")

var expected_color : Color

func prepare_order():
	var obj : SlimeJar = jar.instance()
	Game.add_slime(obj)
	obj.global_position = $TransactionArea/AreaSprite.global_position
	obj.position.y -= 4.0
	
	expected_color = _calculate_expected_color()
	$ColorIndicator/Inside.modulate = expected_color

func _ready():
	randomize()
	prepare_order()
	yield(VisualServer, "frame_post_draw")
	Game.player.connect("item_dropped", self, "_on_item_dropped")
	
func _on_item_dropped(pickable : Pickable):
	if pickable is SlimeJar:
		var jar : SlimeJar = pickable
		yield(VisualServer, "frame_post_draw")
		yield(VisualServer, "frame_post_draw")
		if $TransactionArea.overlaps_area(jar) and jar.is_jar_empty() == false:
			var difference_factor := abs(expected_color.h - jar.final_color.h)
			print(difference_factor)
			queue_free()
			jar.queue_free()
	
func _calculate_expected_color() -> Color:
	return Color.from_hsv(rand_range(0.0, 1.0), 0.8, 0.9)
