extends PopupDialog

onready var main = get_parent()
onready var progress_bar = get_node("VBoxContainer/HBoxContainer2/VBoxContainer/ProgressBar")

var path_text = ""
var after_saving = "stay"

func _on_ProgressDialog_about_to_show():
	set_process(true)
	$VBoxContainer/HBoxContainer/OpenButton.disabled = true
	$VBoxContainer/Label.text = "Saving..."
	progress_bar.visible = true
	if OS.get_name() == "Android":
		$VBoxContainer/HBoxContainer/OpenButton.visible = false
		after_saving = "close"
	$VBoxContainer/Label2.text = ProjectSettings.globalize_path(path_text)
	#$VBoxContainer/Label2.text = path_text.replace("user://", "%APPDATA%/Godot/app_userdata/Music DJ/saves/Exports/")
	$AnimationPlayer.play("fade_in")


func _on_ProgressDialog_popup_hide():
	visible = true
	# Animation
	$AnimationPlayer.play_backwards("fade_in")
	yield(get_tree().create_timer(0.1), "timeout")
	
	progress_bar.value = 0
	
	visible = false


func _on_CancelButton_pressed():
	hide()
	main.can_play = false
	main.get_node("SaveDialog").is_cancelled = true


func _process(delta):
	print(progress_bar.value)
	if progress_bar.value >= progress_bar.max_value:
		$VBoxContainer/HBoxContainer/OpenButton.disabled = false
		$VBoxContainer/Label.text = "Saved"
		progress_bar.visible = false
		
		if after_saving == "close":
			hide()
		else:
			pass
		
		set_process(false)
	else:
		progress_bar.value += delta
		


func _on_OpenButton_pressed():
	if OS.get_name() == "Android":
		OS.alert(ProjectSettings.globalize_path(main.user_dir), "Folder location")
	else:
		OS.shell_open(ProjectSettings.globalize_path(main.user_dir))
