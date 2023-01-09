extends HBoxContainer

onready var dayTextCounter = $Text

var dayAmmount

func _ready():
	dayAmmount = 0

func addDays(var ammount):
	dayAmmount += ammount
	updateText()

func setDays(var ammount):
	dayAmmount = ammount
	updateText()

func updateText():
	dayTextCounter.text = dayAmmount
