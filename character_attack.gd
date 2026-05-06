extends Area2D
@export var speed = 750
var direction = 1
var damage = 1

func _physics_process(delta):
	position.x += speed * direction * delta


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.hurt(damage)
		queue_free()
	elif body.is_in_group("boxes"):
		body.box_break()
		queue_free()
	elif  body.is_in_group("environment"):
		queue_free()
	elif body.is_in_group("itemCrate"):
		body.box_break()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
