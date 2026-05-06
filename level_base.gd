extends Node2D

@onready var player = $player
@onready var spawn_point = $SpawnPoint

@export var level_id: int = 1




func _ready():
	GameState.save_game()
	GameState.current_level = level_id
	player.global_position = spawn_point.global_position
	$mainMusic.play()
	

func _on_win():
	$fadeToBlack.play("fadeIn")
	await $fadeToBlack.animation_finished
	if level_id == 3 :
		GameState.winScene()
	else:
		GameState.next_level()

func _on_killzone_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("enemies"):
		body.die()
		$mainMusic.stop()
