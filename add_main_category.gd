extends Node2D
var categoryName = "Pets"
var childItems = []
var newItems = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameParentItem.text = categoryName
	$AddChildItem.position = Vector2(411, 15)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# (+) button was pushed
func _on_add_child_item_pressed():
	pass

# parent name was changed (enter)
func _on_name_parent_item_text_submitted(new_text):
	print("parent category updated to " + new_text)

#not signal based - called by _on_add_child_item_pressed
func updateChildItems(): 
	print("updating child items")
	for child in newItems: 
		child.position = Vector2(10, childItems.size()*50 + 150) #update position of new list item
		add_child(child)
		childItems.push_back(child)
	newItems.clear() #clear the pending items

# (+) button was pushed
func _on_texture_button_pressed():
	print("add child item")
	var new_child = LineEdit.new()
	newItems.push_back(new_child)
	new_child.placeholder_text = "New Item"
	updateChildItems()
