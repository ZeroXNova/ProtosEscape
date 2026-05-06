extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var exit: RichTextLabel = $Panel/ExitText
@onready var continueLabel: RichTextLabel = $Panel/Continue

var typing_speed = 15.0
var char_progress = 0.0
signal typing_finished

func _ready():
	set_process(false)
	label.text = """	You've failed to make it out!
	
	The security forces have captured you, and have returned you the lab you were born in.
	
	But escape is still possible.
	
	Please try again!"""
	label.visible_characters = 0.0
	char_progress = 0.0
	set_process(true)
	$Panel/ExitText.visible = true
	$AnimationPlayer.play("Skip")

func _process(delta):
	char_progress += typing_speed * delta
	var new_visible = int(char_progress)
	if new_visible > label.visible_characters:
		label.visible_characters = new_visible
		if label.visible_characters >= label.get_total_character_count():
			label.visible_characters = label.get_total_character_count()
			emit_signal("typing_finished")
			set_process(false)
			
func _restart_Game():
	await get_tree().create_timer(1.5).timeout
	label.visible = false
	exit.visible = false
	continueLabel.visible = true
	$AnimationPlayer.play("continue")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		GameState.restart()
