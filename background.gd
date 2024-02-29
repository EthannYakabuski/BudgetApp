extends Node2D
var categoryData

func load_data(): 
	var savedCategoriesFile = FileAccess.open("res://data.json", FileAccess.READ)
	if savedCategoriesFile: 
		var data = savedCategoriesFile.get_as_text()
		categoryData = data
	savedCategoriesFile.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	loadMerchants()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMerchants(): 
	print("loading and populating merchant dropdown")
