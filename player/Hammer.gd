extends Node2D
class_name Hammer

onready var anim = $Anim

func play_swing():
	anim.play("Swing")
	
func play_idle():
	anim.play("Idle")

func is_swinging():
	return anim.current_animation == "Swing"
