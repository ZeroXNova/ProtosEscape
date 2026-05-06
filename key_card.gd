extends RigidBody2D


func _on_body_entered(body):
	if body.name == "player":
		body.keyCard()
		queue_free()
