extends Node2D

@onready var player = $player
@onready var spawn_point = $SpawnPoint

var level



func _ready():
	level = get_tree().current_scene.name
	GameState.save_game()
	player.global_position = spawn_point.global_position
	$mainMusic.play()
	

func _on_win():
	$fadeToBlack.play("fadeIn")
	await $fadeToBlack.animation_finished
	if level == "Level03":
		GameState.winScene()
	else:
		GameState.next_level()

func _on_killzone_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("enemies"):
		body.die()
		$mainMusic.stop()
