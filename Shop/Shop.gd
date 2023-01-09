extends Control


onready var orders = $ClientContainer/Orders

var orderColor


func _ready():
	for order in orders.get_children():
		order.get_child(1).modulate = generateOrderColor(0,0)

func generateOrderColor(var slimeS, var slimeV):
	orderColor = Color.from_hsv(randf(),slimeS,slimeV,1)
	return Color.aquamarine

