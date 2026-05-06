extends StaticBody2D

var cannonScene = preload("res://cannon_upgrade.tscn")
var rocketScene = preload("res://rocket_upgrade.tscn")
var level

func _ready():
	level = get_tree().current_scene.name
	
func box_break():
	$breakSound.play()
	if level == "Level02":
		var upgrade = rocketScene.instantiate()
		get_parent().add_child(upgrade)
		upgrade.global_position = global_position
	if level == "Level03":
		var upgrade = cannonScene.instantiate()
		get_parent().add_child(upgrade)
		upgrade.global_position = global_position
	call_deferred("queue_free")
