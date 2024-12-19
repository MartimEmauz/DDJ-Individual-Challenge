extends CharacterBody2D

# Player stats
var SPEED = 130.0
var damage = 10.0
var range = 50.0

# Leveling
var level = 1
var total_xp = 0
var xp_for_next_level = 100

# Estados
var is_hurt = false
var is_attacking = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var experience_bar : TextureProgressBar

# Signals
signal player_attack(damage, range)
signal level_up(level)
signal increase_health(value)

func _physics_process(delta: float) -> void:
	# Define a direção do player.
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	# Verifica se o jogador está a ser atacado ou a atacar para não cancelar as animações
	if !is_hurt and !is_attacking:
		# Define as animações de correr ou idle
		if direction_x != 0 or direction_y != 0:
			animated_sprite.play("Run")
		else:
			animated_sprite.play("Idle")
	
	# Vira o sprite para a esquerda ou direita
	if direction_x > 0:
		animated_sprite.flip_h = false
	elif direction_x < 0:
		animated_sprite.flip_h = true

	# Reduzi a velocidade no eixo Y para ficar lógico
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED * 0.8

	move_and_slide()

# Atualiza o estado para poder fazer a animação. Timeout serve para alinhar
# os timings das animações
func _on_hurtbox_hurt(damage: Variant) -> void:
	is_hurt = true
	print(name + "lost" + str(damage) + "HP.")
	
	await get_tree().create_timer(0.3).timeout
	animated_sprite.play("Hurt")
	await animated_sprite.animation_finished
	
	is_hurt = false

# Manda o jogador para o menu
func _on_health_die() -> void:
	SceneHandler.go_to_menu()
	
# Chama o ataque quando o mouse1 é pressionado
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack1"):
		attack()
	
# Atualiza o estado, faz a animação e emite o ataque com o dano previamente definido
func attack():
	is_attacking = true
	animated_sprite.play("Attack")
	
	var enemy_hurtboxes = get_tree().get_nodes_in_group("enemy_hurtboxes")
	
	for hurtbox in enemy_hurtboxes:
		if hurtbox:
			hurtbox._on_player_attack(damage, range)
	
	await animated_sprite.animation_finished
	is_attacking = false


	
# Incrementa o valor do XP total quando apanha uma carta de xp
func _on_collect_xp(amount):
	total_xp += amount
	print("Collected XP: ", amount, " | Total XP: ", total_xp)
	experience_bar.value = total_xp
	check_level_up()
	
# Verifica se o player subiu de nível se o xp ultrapassar on necessário
func check_level_up():
	if total_xp >= xp_for_next_level:
		level += 1
		print("Level up! Now level ", level)
		
		level_up.emit(level)
		
		total_xp -= xp_for_next_level  # This line will keep XP carried over from the previous level.
		
		# Aumenta o valor por 50% a cada nível
		xp_for_next_level = int(xp_for_next_level * 1.5)
		
		experience_bar.value = total_xp 
		experience_bar.max_value = xp_for_next_level
		print("Next level requires ", xp_for_next_level, " XP.")
		
func _on_collect_health(value : float):
	increase_health.emit(value)
