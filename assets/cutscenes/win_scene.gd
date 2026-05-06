extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
@onready var exit: RichTextLabel = $Panel/ExitText
@onready var continueLabel: RichTextLabel = $Panel/Continue


var typing_speed = 15.0
var char_progress = 0.0
signal typing_finished

func _ready():
	set_process(false)
	label.text = """ You've managed to escape the forces of N.O.V.A. Laboratories!
	
	But where is Professor Z?
	
	How are you going to find him?
	
	While you contemplate answers to both of these questions, you take a moment to stop and enjoy this new world you're in.
	
	Every journey starts with a single step.
	
	There are many more on this one.
	"""
	label.visible_characters = 0.0
	char_progress = 0.0
	set_process(true)
	exit.visible = true
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
			
func _continueGame():
	await get_tree().create_timer(1.5).timeout
	label.visible = false
	exit.visible = false
	continueLabel.visible = true
	$AnimationPlayer.play("Continue")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		GameState.restart()
