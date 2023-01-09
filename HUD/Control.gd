extends Control


onready var ammountOfClients = $RightBar/Clients/Text
onready var ammountOfDays = $RightBar/Days/Text
onready var points = $Points

var point = 0
var days = 0
var clients = 0

func _ready():
	points.text = "0"
	ammountOfDays.text = "0"
	ammountOfClients.text = "7"

func addPoints(var pts):
	point += pts
	points.text = String(point)

func addDays(var pts):
	days += pts
	ammountOfDays.text = String(days)

func addClients(var pts):
	clients += pts
	ammountOfClients.text = String(clients)
	if ammountOfClients.text == 0:
		endDay()

func endDay():
	pass
