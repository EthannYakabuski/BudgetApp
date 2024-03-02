extends Node2D
var categoryData
var merchants

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
