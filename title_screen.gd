extends Control

var save_exists = false
var path = "user://savegame.save"


func _ready():
	print(OS.get_user_data_dir())

func _input(event):
	if event.is_action_pressed("ui_select"):
		$MessagePlayer.stop()
		$Message.visible = false
		$newGame.visible = true
		if FileAccess.file_exists(path):
			$continue.visible = true
	elif event.is_action_pressed("ui_cancel"):
		if $Message.visible == true:
			get_tree().quit()
		elif $Message.visible == false:
			$Message.visible = true
			$MessagePlayer.play("flash")
			$newGame.visible = false
			$continue.visible = false


func _on_new_game_pressed():
	$ConfirmationDialog.popup_centered()


func _on_continue_pressed():
	if GameState.load_game():
		GameState.skipToLevel(GameState.level_file)
	else:
		print("No valid save file found")


func _on_confirmation_dialog_confirmed() -> void:
	GameState.introScene()
