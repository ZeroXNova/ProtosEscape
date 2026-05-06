extends Area2D


func _on_ready():
	$AnimationPlayer.play("hover")
	
func _on_body_entered(body):
	if body.name == "player":
		body.cannon_level = 3
		GameState.cannon_level = body.cannon_level
		body.upgrade_sound()
		queue_free()
