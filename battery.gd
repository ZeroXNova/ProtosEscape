extends RigidBody2D

func _ready():
	$RichTextLabel.visible = false

func _on_body_entered(body):
	if body.name == "player":
		if body.life < body.max_life and body.life > 0:
			body.battery()
			queue_free()
		else:
			$RichTextLabel.visible = true
			await get_tree().create_timer(0.5).timeout
			$RichTextLabel.visible = false
