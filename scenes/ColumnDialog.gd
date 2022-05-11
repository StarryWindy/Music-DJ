extends "res://scenes/DialogScript.gd"

var column
var column_no


func _ready():
	Variables.connect("theme_changed", self, "on_theme_changed")


func on_theme_changed(new_theme):
	var path = "res://assets/themes/%s/" % new_theme
	$Sprite.texture = load(path.plus_file("column_tear.png"))


func on_Column_Button_pressed(_column_no, _column):
	column = _column
	column_no = _column_no
	
	var pos = _column.column_button.rect_global_position
	pos.x -= rect_size.x/2 - _column.column_button.rect_size.x/2
	pos.y += _column.column_button.rect_size.x
	var viewport_size = get_viewport().get_visible_rect().size
	var pos_plus_size = pos+rect_size+Vector2(16,16)
	var pos_minus_size = pos-rect_size-Vector2(16,16)
	if pos_plus_size.x > viewport_size.x:
		pos.x -= pos_plus_size.x - viewport_size.x
	elif pos.x < 0:
		pos.x = 0 + 16
		
	rect_global_position = pos
	
	var sprite = get_node("Sprite")
	var sprite_pos_x = _column.column_button.rect_global_position.x + \
		_column.column_button.rect_size.x/2
	sprite.global_position.x = sprite_pos_x
	
	popup()
	
	rect_pivot_offset = Vector2(sprite_pos_x - pos.x, 0)


func about_to_show(dim := true):
	# Set title
	var title = "Column " + str(column_no+1)
	$VBoxContainer/VBoxContainer/Label.text = title
	
	
	# Make buttons visible
	if column_no != main.column_index - 1 or main.column_index == 15:
		$VBoxContainer/HBoxContainer/RemoveButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/RemoveButton.disabled = false
	
	var falses = -1
	for i in column.get_children():
		if i is Button and i.text != "":
			falses += 1
	if falses == 0:
		$VBoxContainer/HBoxContainer/ClearButton.disabled = true
		$VBoxContainer/HBoxContainer/PlayButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/ClearButton.disabled = false
		$VBoxContainer/HBoxContainer/PlayButton.disabled = false
	
	.about_to_show()

func _on_ClearButton_pressed():
	column.clear()
	
	# Clear from song
	main.used_columns.erase(column_no)
	for i in 4:
		main.song[i][column_no] = 0

	hide()


func _on_CancelButton_pressed():
	hide()


func _on_RemoveButton_pressed():
	column.remove()
	
	# Clear from song
	main.used_columns.erase(column_no)
	for i in 4:
		main.song[i][column_no] = 0
	main.column_index -= 1
	
	hide()


func _on_PlayButton_pressed():
	main.play_column(column_no, true)
	main.get_node("SoundDialog/AudioStreamPlayer").stop()
	hide()
	
