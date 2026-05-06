extends RigidBody2D

func _integrate_forces(state):
	var v = state.linear_velocity
	v.x = 0
	state.linear_velocity = v


func box_break():
	$breakSound.play()
	$AnimationPlayer.play("break")
	await $AnimationPlayer.animation_finished
	queue_free()
