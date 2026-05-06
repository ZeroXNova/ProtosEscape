extends Area2D
@export var speed = 250


var direction = 1
var damage = 1

func _physics_process(delta):
	position.x += speed * direction * delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.state != body.HURT:
			body.hurt()
			queue_free()
		
	elif body.is_in_group("boxes"):
		queue_free()
	elif  body.is_in_group("environment"):
		queue_free()
	elif body.is_in_group("itemCrate"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
