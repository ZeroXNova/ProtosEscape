extends CharacterBody2D

@onready var ray: RayCast2D = $RayCast2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var gun = $Sprite2D/gun
@export var speed = 65
@export var gravity = 900
@export var drop_chance := 0.5
@export var facing = 1
var lives = 1
var active = false
var vision_distance
var can_attack = true
var shots_fired = 0
var max_shots = 2
var reload_time = 1.0
var AttackScene = preload("res://enemy_attack.tscn")
var BatteryScene = preload("res://battery.tscn")

func _ready():
	var camera = get_viewport().get_camera_2d()
	var viewport_size = get_viewport_rect().size
	if camera:
		vision_distance = viewport_size.x / camera.zoom.x
	else:
		vision_distance = viewport_size.x
	
func _physics_process(delta):
	if not active:
		return
	velocity.y += gravity * delta
	velocity.x = facing * speed
	$Sprite2D.scale.x = facing
	move_and_slide()
	if player:
		check_line_of_sight()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			collision.get_collider().hurt()
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100
	if position.y > 10000:
		queue_free()
		
func check_line_of_sight():
	ray.target_position = Vector2(facing * vision_distance, 0)
	ray.force_raycast_update()
	
	if ray.is_colliding():
		if ray.get_collider() == player:
			await get_tree().create_timer(0.3).timeout
			if can_attack:
				
				attack()
			
			
func _on_screen_entered():
	active = true
	
func _on_screen_exited():
	active = false

func hurt(damage):
	lives -= damage
	if lives <= 0:
		call_deferred("die")
		
func die():
	if randf() <= drop_chance:
		var battery = BatteryScene.instantiate()
		get_parent().add_child(battery)
		battery.global_position = global_position
	call_deferred("queue_free")
	
func attack():
	if not can_attack:
		return
	can_attack = false
	shots_fired = 0
	fire_next_shot()
	
func fire_next_shot():
	var attack_instance = AttackScene.instantiate()
	get_parent().add_child(attack_instance)
	attack_instance.direction = facing
	attack_instance.global_position = gun.global_position
	$shootSound.play()
	shots_fired += 1
	if shots_fired < max_shots:
		await get_tree().create_timer(0.2).timeout
		fire_next_shot()
	else:
		reload()
		
func reload():
	await get_tree().create_timer(reload_time).timeout
	can_attack = true
