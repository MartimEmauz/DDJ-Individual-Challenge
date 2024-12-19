extends CharacterBody2D

const SPEED = 30.0
const ATTACK_COOLDOWN = 1.5
const HURT_COOLDOWN = 1

@onready var player = get_tree().get_first_node_in_group("player")
@onready var hurtbox = get_tree().get_first_node_in_group("hurt_boxes")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slime: CharacterBody2D = $"."
var attack_timer: Timer
var hurt_cooldown_timer: Timer  # Timer for the hurt cooldown

var xp_item: PackedScene = preload("res://Scenes/Utility/xp_card.tscn")

var is_hurt = false
var is_attacking = false
var is_dying = false
var can_attack = true  # Flag to check if the slime can attack

signal slime_attack(damage)

func _ready():
	# Setup the timers
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = ATTACK_COOLDOWN
	attack_timer.one_shot = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	
	hurt_cooldown_timer = Timer.new()
	add_child(hurt_cooldown_timer)
	hurt_cooldown_timer.wait_time = HURT_COOLDOWN
	hurt_cooldown_timer.one_shot = true
	hurt_cooldown_timer.connect("timeout", Callable(self, "_on_hurt_cooldown_timeout"))
	
	# Connect the slime's attack signal
	if hurtbox and not is_connected("slime_attack", Callable(hurtbox, "_on_slime_attack")):
		connect("slime_attack", Callable(hurtbox, "_on_slime_attack"))
	else:
		print("Failed to connect to hurtbox in _ready!")

func _physics_process(delta: float) -> void:
	var distance = (slime.position - player.position).length()
	var direction = null
		
	if !is_dying:
		direction = global_position.direction_to(player.global_position)
		if distance < 20 and !is_attacking and !is_hurt and can_attack:  # Check if the slime can attack
			attack()
			print(name, "Attacking with distance: ", distance)
		else:
			move_towards_player(direction)
	else: 
		return
	
func move_towards_player(direction):
	if direction and !is_hurt and !is_dying and !is_attacking:
		animated_sprite.play("Walk")
		velocity = direction * SPEED
		move_and_slide()

func attack():
	if !can_attack:  # Don't attack if we're in the hurt cooldown state
		return
	
	is_attacking = true
	
	# Emit the signal safely
	if hurtbox:
		slime_attack.emit(5)
	else:
		print("Hurtbox is null; cannot emit signal.")
	
	# Play the attack animation
	animated_sprite.play("Attack")
	await animated_sprite.animation_finished
	is_attacking = false
	
	# Start the attack cooldown after an attack
	attack_timer.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if !is_dying and can_attack:
		attack()

func _on_health_die() -> void:
	is_dying = true
	print("slime is dying")
	await get_tree().create_timer(1).timeout
	animated_sprite.play("Dead")
	drop_xp()
	await animated_sprite.animation_finished
	queue_free()

func _on_enemy_hurtbox_hurt(damage: Variant) -> void:
	if !is_dying:
		is_hurt = true
		print(name + " lost " + str(damage) + " HP.")
		
		# Start the hurt cooldown after getting hurt
		hurt_cooldown_timer.start()
		
		await get_tree().create_timer(0.3).timeout
		animated_sprite.play("Hit")
		await animated_sprite.animation_finished
		is_hurt = false

func _on_attack_timer_timeout() -> void:
	# This timer controls the cooldown after an attack is made.
	can_attack = true  # Reset the attack flag to allow the slime to attack again.

func _on_hurt_cooldown_timeout() -> void:
	# This timer controls the cooldown after the slime gets hurt.
	can_attack = true  # Reset the attack flag to allow the slime to attack again.

func drop_xp():
	var parent_node = get_parent()  # Define the parent node of the slime (the spawner) to avoid errors
	if parent_node:
		var new_card = xp_item.instantiate()
		parent_node.add_child(new_card)
		new_card.global_position = global_position
	else:
		print("Error: Cannot drop XP. Parent node is null.")
