extends Node2D

var categoryData
var uiElements = []
	
func load_data(): 
	var savedCategoriesFile = FileAccess.open("res://data.json", FileAccess.READ)
	if savedCategoriesFile: 
		var data = savedCategoriesFile.get_as_text()
		categoryData = data
	savedCategoriesFile.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	#$NameParentItem.text = categoryName
	$AddChildItem.position = Vector2(191, 555)
	load_data()
	drawCategories()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#remove_child on all objects in the uiElements array then empties it
func clearUI(): 
	for element in uiElements: 
		remove_child(element)
	uiElements.clear()
	
#draws the category names
func drawCategories(): 
	#todo place into scrollable container
	var json = JSON.new()
	print("drawing category names")
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
		newProgress.value = (category["spent"]/category["budgeted"])*100
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
		uiElements.push_back(newItem)
		uiElements.push_back(newProgress)
		uiElements.push_back(newAddition)
		
		#increment items for UI layout
		items = items + 1

# (+) button was pushed
func _on_texture_button_pressed():
	print("+ button pushed")
	var newEntryRaw = "{\"name\": \"New\", \"budgeted\": 100, \"rolledOver\": 0, \"spent\": 0, \"remaining\": 100}"
	var json = JSON.new()
	var parsedData = json.parse(newEntryRaw)
	var newEntry = json.get_data()
	#print(newEntry)
	
	#get the existing data
	var existingData = json.parse(categoryData)
	var finalData = json.get_data()
	var categories = finalData["categories"]
	categories.push_back(newEntry)
	finalData["categories"] = categories
	#print(categories)
	print(finalData)
	
	var jsonString = json.stringify(finalData)
	var parsed = json.parse(jsonString)
	var new_data_to_write = json.get_data()
	var savedCategoriesFile = FileAccess.open("res://data.json", FileAccess.WRITE)
	if savedCategoriesFile:
		print(new_data_to_write)
		var store = json.stringify(new_data_to_write)
		savedCategoriesFile.store_string(store)
	savedCategoriesFile.close()
	#clear the UI in order to rebuild the category elements
	load_data()
	clearUI()
	drawCategories()
	
