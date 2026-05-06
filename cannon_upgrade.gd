extends Area2D

var player = null

func _on_ready():
	$AnimationPlayer.play("hover")
	
func _on_body_entered(body):
	if body.name == "player":
		player = body
		body.cannon_level = 3
		GameState.cannon_level = body.cannon_level
		$CollisionShape2D.disabled = true 
		hide()
		$upgradeDialog.popup_centered()
		get_tree().paused = true

func _on_upgrade_dialog_confirmed():
	get_tree().paused = false
	if player:
		player.upgrade_sound()
	
	queue_free()
