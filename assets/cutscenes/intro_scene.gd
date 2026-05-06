extends CanvasLayer

@onready var label: RichTextLabel = $Panel/RichTextLabel
#@onready var text_beep: AudioStreamPlayer2D = $AudioStreamPlayer2D

var typing_speed = 15.0
var char_progress = 0.0
signal typing_finished

func _ready():
	set_process(false)
	label.text = """	Hi, my name's Proto! \n
	The year is 23XX, and I'm a robot made by Professor Z. I've spent my whole life locked up here in N.O.V.A Laboratories.\n
	Since he designed me to help humanity,the Professor gave me the ability to install new peices of technology to fit whatever situation I find myself in!\n
	Unfortunately, someone has taken the Professor, and has tried to corrupt my code. I need to get out of here to find Professor Z, and help humanity!"""
	label.visible_characters = 0.0
	char_progress = 0.0
	$AnimationPlayer.play("fadeIn")
	await $AnimationPlayer.animation_finished
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
			
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		GameState.next_level()
