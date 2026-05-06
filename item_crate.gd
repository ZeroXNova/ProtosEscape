extends StaticBody2D

var cannonScene = preload("res://cannon_upgrade.tscn")
var rocketScene = preload("res://rocket_upgrade.tscn")

	
func box_break():
	$breakSound.play()
	match GameState.current_level:
		2:
			var upgrade = rocketScene.instantiate()
			get_parent().add_child(upgrade)
			upgrade.global_position = global_position
		3:
			var upgrade = cannonScene.instantiate()
			get_parent().add_child(upgrade)
			upgrade.global_position = global_position
	call_deferred("queue_free")
