extends Node2D
var categoryName = "Pets"
var childItems = []
var newItems = []

var definedCategories = [];

func save_data():
	var file = FileAccess.open("user://saved_categories.dat", FileAccess.WRITE)
	if file:
		file.store_string("Internet\nPets\nPhone\nGroceries\n")
		file.close()
		print("Game data saved!")
	
func load_data(): 
	var savedCategoriesFile = FileAccess.open("user://saved_categories.dat", FileAccess.READ)
	if savedCategoriesFile: 
		var data = savedCategoriesFile.get_as_text()
		var categoryNames = data.split("\n")
		savedCategoriesFile.close()
		definedCategories = categoryNames
		print(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameParentItem.text = categoryName
	$AddChildItem.position = Vector2(180, 562)
	save_data()
	load_data()
	drawCategories()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#draws the category names
func drawCategories(): 
	print("drawing category names")
	var items = 1
	for child in definedCategories: 
		var newItem = LineEdit.new()
		newItem.position = Vector2(10, items*50 + 150) #update position of new list item
		newItem.text = child
		items = items + 1
		add_child(newItem)

# (+) button was pushed
func _on_texture_button_pressed():
	print("+ button pushed")
