extends MarginContainer
@onready var life_counter = $HBoxContainer/LifeCounter.get_children()
@onready var key_counter = $HBoxContainer/KeyCounter.get_children()

func _ready():
	update_keys(0)

func update_life(value):
	for i in range(life_counter.size()):
		life_counter[i].visible = value > i
		
		
func update_keys(value):
	$HBoxContainer/KeyCounter.show()
	for i in key_counter.size():
		key_counter[i].visible = value > i
