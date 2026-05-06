extends Node

var num_levels = 3
var current_level = 0
var game_scene = "res://main.tscn"
var title_screen = "res://title_screen.tscn"
var intro_scene = "res://assets/cutscenes/intro_scene.tscn"
var death_scene = "res://assets/cutscenes/lose_scene.tscn"
var win_scene = "res://assets/cutscenes/win_scene.tscn"
var life = 5
var max_jumps = 0
var cannon_level = 1
var level_path = "res://level01.tscn"

const SAVE_PATH = "user://savegame.save"


func restart():
	current_level = 0
	life = 5
	max_jumps = 0
	cannon_level = 1
	get_tree().change_scene_to_file(title_screen)
	
func next_level():
	current_level += 1
	print(current_level)
	if current_level <= num_levels:
		get_tree().change_scene_to_file(game_scene)
		
func skipToLevel(level_path):
	get_tree().change_scene_to_file(level_path)
		
func introScene():
	get_tree().change_scene_to_file(intro_scene)
	
func deathScene():
	get_tree().change_scene_to_file(death_scene)
	
func winScene():
	get_tree().change_scene_to_file(win_scene)
	
func save_game():
	var save_data = {
		"life": life,
		"cannon_level": cannon_level,
		"max_jumps": max_jumps,
		"level_path": level_path,
		"current_level": current_level
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	print(FileAccess.file_exists(SAVE_PATH))
	
func load_game() -> bool:
	if !FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		print("Failed to open save file.")
		return false
	var data = JSON.parse_string(file.get_as_text())
	if data == null:
		print("Save file corrupted.")
		return false
	life = data.get("life", 5)
	cannon_level = data.get("cannon_level", 1)
	max_jumps = data.get("max_jumps", 1)
	level_path = data.get("level_path", "res://level01.tscn")
	current_level = int(data.get("current_level", 1))
	return true
	
