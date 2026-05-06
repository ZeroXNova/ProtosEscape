extends Area2D

@export var door_type : String

signal win


func _ready():
	match door_type:
		"enter":
			$Sprite2D.texture = preload("res://assets/enterdoorway.png")
		"exit":
			$Sprite2D.texture = preload("res://assets/doorway.png")
			
func _on_body_entered(body):
	if body.name == "player":
		if body.keysFound >= 3:
			print("exited")
			body.freeze()
			$AudioStreamPlayer2D.play()
			await $AudioStreamPlayer2D.finished
			win.emit()
		else:
			print("not enough keys!, find " + str(3-body.keysFound) + " more keys!")
