extends Node2D
var categoryData
var merchants
var transactions
var uiElements = []
signal loadtransactions
@export var main: PackedScene
@export var categoryName: String

func load_data(): 
	var savedCategoriesFile = FileAccess.open("res://data.json", FileAccess.READ)
	if savedCategoriesFile: 
		var data = savedCategoriesFile.get_as_text()
		categoryData = data
	savedCategoriesFile.close()
	var json = JSON.new()
	var parsedData = json.parse(categoryData)
	var finalData = json.get_data()
	merchants = finalData["merchants"]

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	loadMerchants()
	loadTransactions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func clearUI():
	$CategoryLabel.visible = false
	$PurchaseAmountInput.visible = false
	$Notes.visible = false
	$NotesLabel.visible = false
	$MenuButton.visible = false
	$SaveButton.visible = false
	$BackButton.visible = false

func loadTransactions(): 
	print("loading and populating transaction tree")
	var json = JSON.new()
	var parsedData = json.parse(categoryData)
	var finalData = json.get_data()
	var data = finalData["categories"]
	print($CategoryLabel.text)
	for category in data: 
		if(category.name == categoryName):
			print("found match") 
			transactions = category["transactions"]
	var tree = $Tree
	var root = tree.create_item()
	root.set_text(0, "Transactions")
	
	for transaction in transactions:
		print(transaction) 
		var child = tree.create_item(root)
		var itemString = transaction["amount"] + "    " + transaction["merchant"]
		child.set_text(0, itemString)
			

func loadMerchants():
	print("loading and populating merchant dropdown")
	var menu = $MenuButton
	var popUp = menu.get_popup()
	for merchant in merchants: 
		popUp.add_item(merchant)
	popUp.connect("id_pressed", onMerchantItemSelected)

func onMerchantItemSelected(id): 
	print("selected merchant " + str(id))
	var currentIndex = 0
	var returnMerchant = ""
	for merchant in merchants: 
		if(currentIndex == id):
			returnMerchant = merchant
		currentIndex = currentIndex + 1
	$MenuButton.text = returnMerchant


func _on_save_button_pressed():
	print("saving transaction")
	var notes = $Notes.text
	var merchant = $MenuButton.text
	var amount = $PurchaseAmountInput.text
	var categoryName = $CategoryLabel.text
	var json = JSON.new()
	var transactionObjectString = "{\"merchant\":\"{0}\",\"amount\":\"{1}\",\"notes\":\"{2}\"}".format([merchant, amount, notes])
	var parsedData = json.parse(transactionObjectString)
	var newEntry = json.get_data()
	var parsedDataTotal = json.parse(categoryData)
	var finalData = json.get_data()
	var categories = finalData["categories"]
	for category in categories: 
		if(category.name == categoryName): 
			var transactionArray = category["transactions"]
			transactionArray.push_back(newEntry)
	finalData["categories"] = categories
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
	clearUI()
	add_child(main.instantiate())
	


func _on_back_button_pressed():
	print("cancelling transaction")
	clearUI()
	add_child(main.instantiate())
