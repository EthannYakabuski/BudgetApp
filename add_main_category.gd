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
	drawTitleAmounts()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#remove_child on all objects in the uiElements array then empties it
func clearUI(): 
	for element in uiElements: 
		remove_child(element)
	uiElements.clear()
	
#called when category lineEdit is renamed
func categoryRename(newName, controlIndex): 
	print("category renamed to " + newName)
	saveCategoryRename(controlIndex,newName)
	
#
func saveCategoryRename(index, newName): 
	print("saving category")
	print(str(index))
	print("newName: " + newName)
	var json = JSON.new()
	#get the existing data
	var existingData = json.parse(categoryData)
	var finalData = json.get_data()
	#access the categories space of the data
	var categories = finalData["categories"]
	#find the category that needs to be updated
	var amountTraversed = 0
	var indexToFind = int(index)
	for category in categories: 
		if(amountTraversed == int(indexToFind-1)): 
			print("updating name")
			category.name = newName
		amountTraversed = amountTraversed + 1
	#update the handle
	finalData["categories"] = categories
	#print(finalData)
	
	#prepare the data for storage
	var jsonString = json.stringify(finalData)
	var parsed = json.parse(jsonString)
	var new_data_to_write = json.get_data()
	#write to the file
	var savedCategoriesFile = FileAccess.open("res://data.json", FileAccess.WRITE)
	if savedCategoriesFile:
		print(new_data_to_write)
		var store = json.stringify(new_data_to_write)
		savedCategoriesFile.store_string(store)
	savedCategoriesFile.close()
	load_data()

#in StringPackedArray
#out String - except for the last element of the StringPackedArray
func removeLastChunk(stringArray): 
	var len = stringArray.size()
	var outString = ""
	var cur = 0
	for string in stringArray: 
		if(cur != len-1):
			outString = outString + " " + string
		cur = cur + 1
	return outString
	
#draws the title amounts
func drawTitleAmounts(): 
	print("drawing title amounts")
	var json = JSON.new()
	var parsedData = json.parse(categoryData)
	var finalData = json.get_data()
	var titles = finalData["titles"]
	$IncomeLabel/IncomeAmountLabel.text = str(titles.income)
	$ExpensesLabel/ExpenseAmountLabel.text = str(titles.expenses)
	$SavingsLabel/SavingsAmountLabel.text = str(titles.savings)
	
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
		newItem.position = Vector2(10, items*75 + 50) #update position of new list item
		newItem.text = category["name"]
		add_child(newItem)
		#player.hit.connect(_on_player_hit.bind("sword", 100))
		newItem.connect("text_submitted", categoryRename.bind(items))
		#adds the event listener for renaming category
		#add the progress bar
		var newProgress = TextureProgressBar.new()
		newProgress.texture_under = load("res://images/bar.png")
		newProgress.texture_progress = load("res://images/bar.png")
		newProgress.tint_progress = "3cba00b8"
		newProgress.value = (category["spent"]/category["budgeted"])*100
		newProgress.position = Vector2(100, items*75 + 50)
		newProgress.scale.x = 0.5
		newProgress.scale.y = 0.7
		add_child(newProgress)
		#add the arrow button
		var newAddition = TextureButton.new()
		newAddition.texture_normal = load("res://images/arrow button.png");
		newAddition.position = Vector2(400, items*75 + 33)
		newAddition.scale.x = 0.5
		newAddition.scale.y = 0.5
		add_child(newAddition)
		uiElements.push_back(newItem)
		uiElements.push_back(newProgress)
		uiElements.push_back(newAddition)
		#add the budgetted label
		var budgettedLabel = Label.new()
		budgettedLabel.position = Vector2(10, items*75 + 85)
		budgettedLabel.text = "Budget: " + str(category["budgeted"])
		budgettedLabel.modulate = Color(0,0,0,1)
		budgettedLabel.add_theme_font_size_override("font_size", 12)
		add_child(budgettedLabel)
		#add the rolled over label
		var rolledLabel = Label.new()
		rolledLabel.position = Vector2(100, items*75 + 85)
		rolledLabel.text = "Rolled Over: " + str(category["rolledOver"])
		rolledLabel.modulate = Color(0,0,0,1)
		rolledLabel.add_theme_font_size_override("font_size", 12)
		add_child(rolledLabel)
		#add the spent label
		var spentLabel = Label.new()
		spentLabel.position = Vector2(210, items*75 + 85)
		spentLabel.text = "Spent: " + str(category["spent"])
		spentLabel.modulate = Color(0,0,0,1)
		spentLabel.add_theme_font_size_override("font_size", 12)
		add_child(spentLabel)
		#add the remaining label
		var remainingLabel = Label.new()
		remainingLabel.position = Vector2(290, items*75 + 85)
		remainingLabel.text = "Remains: " + str(category["remaining"])
		remainingLabel.modulate = Color(0,0,0,1)
		remainingLabel.add_theme_font_size_override("font_size", 12)
		add_child(remainingLabel)
		
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
	#access the categories space of the data
	var categories = finalData["categories"]
	#add the new entry
	categories.push_back(newEntry)
	#update the handle
	finalData["categories"] = categories
	print(finalData)
	
	#prepare the data for storage
	var jsonString = json.stringify(finalData)
	var parsed = json.parse(jsonString)
	var new_data_to_write = json.get_data()
	#write to the file
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
	
