extends HBoxContainer

var jarContent = [1,2,3,2,1,3,1,3,1,2]

onready var UIJarContent = $UIJarContent

var slimeData = {
0:{
"name": "noSlime",
"Color": Color(0,0,0,0),
"locked":0
},

1:{
"name": "greenSlime",
"Color": Color(0,1,0,1),
"locked":0
},

2:{
"name": "redSlime",
"Color": Color(1,0,0,1),
"locked":0
},

3:{
"name": "blueSlime",
"Color": Color(0,0,1,1),
"locked":0
}
}

#dwie metody służące do operacji na stacku w celu umieszczania ID poszczególnych slime'ów do porównania z dictem 
#wszystkich szlamów oraz wyboru adekwatnego koloru; kolory do przystosowania

func _ready():
	update_UIJar()


func add_slime_to_jar(var slimeID):
	var insertID = jarContent.find_last(0)
	if insertID != -1 and insertID != 9:
		jarContent.append(slimeID)
	update_UIJar()

func remove_slime_from_jar():
	var iterator = 0
	while jarContent[iterator] == 0:
		iterator+=1
		pass
	jarContent[iterator] = 0
	update_UIJar()

func update_UIJar():
	var id = 0
	for x in UIJarContent.get_children():
		x.color = slimeData[jarContent[id]].Color
		id += 1
