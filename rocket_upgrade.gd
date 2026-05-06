extends Area2D



func _on_ready():
	$AnimationPlayer.play("hover")
	
	
func _on_body_entered(body):
	if body.name == "player":
		body.max_jumps += 1
		GameState.max_jumps = body.max_jumps
		body.upgrade_sound()
		queue_free()
