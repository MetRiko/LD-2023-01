extends HBoxContainer

onready var orderGen = $"."

func completeOrder(var orderID):
	self.get_child(orderID).get_child(1).color = orderGen.generateOrderColor()
