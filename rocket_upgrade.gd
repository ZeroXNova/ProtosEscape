extends Area2D

var player = null

func _on_ready():
	$AnimationPlayer.play("hover")
	
	
func _on_body_entered(body):
	if body.name == "player":
		player = body
		body.max_jumps += 1
		GameState.max_jumps = body.max_jumps
		$CollisionShape2D.disabled = true 
		hide()
		$upgradeDialog.popup_centered()
		get_tree().paused = true


func _on_upgrade_dialog_confirmed() -> void:
	get_tree().paused = false
	if player:
		player.upgrade_sound()
	
	queue_free()
