extends Node2D
class_name Hammer

func play_swing():
	$Anim.play("Swing")
	
func play_idle():
	$Anim.play("Idle")
