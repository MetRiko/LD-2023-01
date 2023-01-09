extends KinematicBody2D

signal jar_delivered

const jar = preload("res://pickable/SlimeJar.tscn")

var expected_color : Color

func prepare_order():
	var obj : SlimeJar = jar.instance()
	Game.add_slime(obj)
	obj.global_position = $TransactionArea/AreaSprite.global_position
	obj.position.y -= 4.0
	
	expected_color = _calculate_expected_color()
	$ColorIndicator/Inside.modulate = expected_color

func move_to_position(pos: Vector2):
	$ColorIndicator.visible = false
	$TransactionArea.visible = false

func init():
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
			var color_match_factor := 1.0 - abs(expected_color.h - jar.final_color.h) 
			var fill_factor := jar.get_fill_level()
			print(color_match_factor, ' : ', fill_factor)
#			queue_free()
			jar.queue_free()
			emit_signal("jar_delivered", fill_factor, color_match_factor)
	
func _calculate_expected_color() -> Color:
	return Color.from_hsv(rand_range(0.0, 1.0), 0.8, 0.9)
