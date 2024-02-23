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
	#$NameParentItem.text = categoryName
	$AddChildItem.position = Vector2(180, 562)
	load_data()
	drawCategories()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#draws the category names
func drawCategories(): 
	#todo place into scrollable container
	var json = JSON.new()
	print("drawing category names")
	print(categoryData)
	var parsedData = json.parse(categoryData)
	var finalData = json.get_data()
	var categories = finalData["categories"]
	var items = 1
	for category in categories: 
		#add the editable category name
		var newItem = LineEdit.new() #todo add change listener
		newItem.position = Vector2(10, items*75 + 100) #update position of new list item
		newItem.text = category["name"]
		add_child(newItem)
		#add the progress bar
		var newProgress = TextureProgressBar.new()
		newProgress.texture_under = load("res://images/bar.png")
		newProgress.texture_progress = load("res://images/bar.png")
		newProgress.tint_progress = "3cba00b8"
		newProgress.value = 50
		newProgress.position = Vector2(100, items*75 + 100)
		newProgress.scale.x = 0.5
		newProgress.scale.y = 0.7
		add_child(newProgress)
		#add the arrow button
		var newAddition = TextureButton.new()
		newAddition.texture_normal = load("res://images/arrow button.png");
		newAddition.position = Vector2(400, items*75 + 83)
		newAddition.scale.x = 0.5
		newAddition.scale.y = 0.5
		add_child(newAddition)
		#increment items for UI layout
		items = items + 1

# (+) button was pushed
func _on_texture_button_pressed():
	print("+ button pushed")
