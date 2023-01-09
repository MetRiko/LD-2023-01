extends HBoxContainer

onready var clientTextCounter = $Text

var clientAmmount

func _ready():
	clientAmmount = 0

func addClients(var ammount):
	clientAmmount += ammount
	updateText()

func setClients(var ammount):
	clientAmmount = ammount
	updateText()

func updateText():
	clientTextCounter.text = clientAmmount
