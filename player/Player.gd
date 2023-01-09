extends KinematicBody2D
class_name Player

signal item_dropped

const MAX_SPEED := 160
const ACCELERATION := 20

onready var anim := $Anim
onready var hammer := $Hammer
onready var hammer_hitbox := $HammerHitbox
onready var start_hammer_pos : Vector2
var hammer_locked_pos := Vector2.ZERO
var move_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var hammer_pos_radius := Vector2(16.0, 8.0)

func _ready():
	hammer.connect("hit", self, "_on_hit")
	$GelPickupHitbox.connect("area_entered", self, "_on_gel_entered")
	Game.player = self
	
func _on_gel_entered(gel_area : Area2D):
	var jar = get_item_in_pocket()
	if jar is SlimeJar:
		var gel : SlimeParticle = gel_area.get_parent()
		var amount_to_extract = 1
		var overflow = jar.add_gel(gel.start_color, amount_to_extract)
		gel.extract_some_gel(amount_to_extract - overflow)
		if overflow == 0:
			Audio.play("OnSlimePick")
		else:
			Audio.play("OnSlimePickTooMuch")

func _on_hit():
	var slime_hitted := false
	var egg_hitted := false
	for area in hammer_hitbox.get_overlapping_areas():
		if area.get_parent() is Slime:
			area.get_parent().do_squish()
			slime_hitted = true
		if area is SlimeEgg:
			area.set_ready_to_break()
			egg_hitted = true
#	if not slime_hitted:
	Audio.play("OnHammerHit")
	if slime_hitted:
		Audio.play("OnSlimeHit")
	
	if not slime_hitted:
		$HammerHitbox/HitParticles.restart()
		$HammerHitbox/HitParticles.emitting = true
	$HammerHitbox/HammerIndicator.modulate = Color(0.8, 0.8, 0.8, 0.6)

func get_item_in_pocket():
	return $Pocket.get_child(0) if $Pocket.get_child_count() > 0 else null

func _input(event):
	if event.is_action_pressed("game_swing") and hammer.visible:
		hammer_locked_pos = hammer.position
		hammer.play_swing()
		$HammerHitbox/HammerIndicator.modulate = Color.white
	if event.is_action_pressed("game_action"):
		if $Pocket.get_child_count() == 0:
			var closest_distance := 100000.0
			var closest_pickable : Pickable
			for area in $PickingHitbox.get_overlapping_areas():
				if area is Pickable and area.is_pickable():
					var dis = global_position.distance_squared_to(area.global_position)
					if dis < closest_distance:
						closest_distance = dis
						closest_pickable = area
			if closest_pickable:
				if closest_pickable is SlimeJar:
					Audio.play("OnJarPick")
				elif closest_pickable is SlimeEgg:
					Audio.play("OnEggPick")
				closest_pickable.pick_by($Pocket)
				closest_pickable.position = Vector2.ZERO
				_disable_hammer()

	if event.is_action_released("game_action"):
		if $Pocket.get_child_count() > 0:
			var obj = $Pocket.get_child(0)
			obj.drop_on(get_parent())
			if obj is SlimeJar:
				obj.reset_angle_level_with_animation()
			obj.position = position
			_enable_hammer()
			Audio.play("OnDrop")
			emit_signal("item_dropped", obj)

func _process(_delta):
	hammer_hitbox.global_position = global_position + hammer.hammer_elipse_vec * 4.0
	
	if $Pocket.get_child_count() > 0:
		var jar = $Pocket.get_child(0)
		if jar is SlimeJar:
			var target_angle_level = velocity.x / MAX_SPEED
			var next_angle_level = lerp(jar.angle_level, target_angle_level, 0.08)
			jar.change_angle_level(next_angle_level)

func _physics_process(delta):
	move_direction = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	
	var hammer_factor := 0.4 if hammer.is_swinging() else 1.0
	
	velocity = Vector2(
		lerp(velocity.x, move_direction.x * MAX_SPEED * hammer_factor, ACCELERATION * delta),
		lerp(velocity.y, move_direction.y * MAX_SPEED * hammer_factor, ACCELERATION * delta)
	)
	
	_update_animations()
	
	var new_velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, 0.785398, false)
	
	for i in range(get_slide_count()):
		var obj = get_slide_collision(i).collider
		if obj is Slime:
			var push_force_factor = lerp(1.0, 0.2, obj.proper_scale * obj.proper_scale)
			obj.linear_velocity = velocity.normalized() * MAX_SPEED * push_force_factor
	
	velocity = new_velocity

func _update_animations():
	if _is_moving():
		if anim.current_animation != "Walk":
			anim.play("Walk", 0.1, 2.0)
	else:
		if anim.current_animation != "Idle":
			anim.play("Idle")

func _enable_hammer():
	hammer.visible = true
	hammer_hitbox.visible = true

func _disable_hammer():
	hammer.visible = false
	hammer_hitbox.visible = false

func _is_hammer_enabled():
	return hammer.visible

func _get_distance_to_mouse():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0))

func _get_viewing_angle():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return atan2(diff.y, diff.x)

func _is_moving():
	return move_direction != Vector2.ZERO
