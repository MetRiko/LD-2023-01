extends Area2D
class_name SlimeJar

onready var sprite = $Sprite

func _ready():
	pass

func _physics_process(delta):
	pass

func _on_mouse_entered():
	sprite.scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	sprite.scale = Vector2(1.0, 1.0)
