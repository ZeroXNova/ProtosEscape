extends Node

func _ready():
	var level_num = GameState.current_level
	var path = "res://level%02d.tscn" % level_num
	GameState.level_path = path
	if FileAccess.file_exists(path):
		var level = load(path).instantiate()
		add_child(level)
	else:
		push_warning("Level not found at path: " + path)
		GameState.restart()
