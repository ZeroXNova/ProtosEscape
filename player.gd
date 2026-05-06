extends CharacterBody2D

@onready var cannon = $Sprite2D/cannon
@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300

signal life_changed
signal keyFound
signal died

enum {IDLE, RUN, JUMP, SHOOT, HURT, DEAD}
var AttackScene = preload("res://character_attack.tscn")
var state = IDLE
var life
var max_life = 5
var jumpCount = 0
var max_jumps
var keysFound = 0
var cannon_level
var can_attack = true
var can_move = true

func _ready():
	life = GameState.life
	call_deferred("set_life", life)
	max_jumps = GameState.max_jumps
	cannon_level = GameState.cannon_level
	randomize()
	change_state(IDLE)
	

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.stop()
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			set_life(life)
			$AnimationPlayer.play("hurt")
			await $AnimationPlayer.animation_finished
			change_state(IDLE)
		JUMP:
			$AnimationPlayer.stop()
			if jumpCount < 1:
				$AnimationPlayer.play("jump")
				await get_tree().create_timer(0.25).timeout
			elif jumpCount <2:
				$AnimationPlayer.play("double_jump")
				await get_tree().create_timer(0.25).timeout
			return
		DEAD:
			freeze()
			died.emit()
			hide()
			set_physics_process(false)
			GameState.deathScene()

func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	velocity.x = 0
	if can_move:
		if right:
			velocity.x += run_speed
			$Sprite2D.scale.x = 1
		if left:
			velocity.x -= run_speed
			$Sprite2D.scale.x = -1
		if shoot:
			if can_attack:
				shoot()
		if jump and is_on_floor():
			jumpCount += 1
			change_state(JUMP)
			velocity.y = jump_speed
		if jump and state == JUMP and jumpCount < max_jumps and jumpCount >= 0:
				jumpCount += 1
				change_state(JUMP)
				velocity.y = jump_speed
		if state == IDLE and velocity.x != 0:
			change_state(RUN)
		if state == RUN and velocity.x == 0:
			change_state(IDLE)
		if state == JUMP and is_on_floor():
			jumpCount = 0
			change_state(IDLE)
		if state in [IDLE, RUN] and !is_on_floor():
			change_state(JUMP)
		
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemies"):
			hurt()

				
func shoot():
	var attack_instance = AttackScene.instantiate()
	get_parent().add_child(attack_instance)
	var direction = sign($Sprite2D.scale.x)
	attack_instance.damage = cannon_level
	attack_instance.direction = direction
	attack_instance.global_position = cannon.global_position
	can_attack = false
	$AnimationPlayer.play("shoot")
	$shootSound.play()
	await get_tree().create_timer(0.25).timeout
	can_attack = true
	
func upgrade_sound():
	$upgrade.play()

func keyCard():
	keysFound += 1
	keyFound.emit(keysFound)
	if keysFound < 3:
		$keycard.play()
	elif keysFound >= 3:
		$unlock.play()
	
func set_life(value):
	life = value
	life_changed.emit(life)
	GameState.life = life
	if life <= 0:
		die()

func battery():
	life += 1
	set_life(life)

		
func hurt():
	if state != HURT:
		change_state(HURT)

func die():
	if state != DEAD:
		change_state(DEAD)
		
func freeze():
	can_move = false
	velocity = Vector2.ZERO
	set_physics_process(false)
	$AnimationPlayer.stop()
