extends Node2D

@onready var menu = preload("res://Scenes/UI/menu.tscn")
@onready var powerup_screen_scene = preload("res://Scenes/UI/power_up_screen.tscn")

func _ready() -> void:
	pass

func _on_player_level_up(level: Variant) -> void:
	get_tree().paused = true
	show_powerup_screen()

func show_powerup_screen():
	var powerup_screen = powerup_screen_scene.instantiate()
	add_child(powerup_screen)
	
	print("showing powerup")
	
	powerup_screen.select_powerup.connect(_on_powerup_selected)

func _on_powerup_selected(power : String, value : float):
	print("Selected Power-UP: ", power, "With value: ", value)
	apply_powerup(power,value)
	
	get_tree().paused = false
	
func apply_powerup(power : String, value : float):
	var player = get_node("Player")
	print("applying power: ", power)
	if player:
		match power:
			"health":
				player._on_collect_health(value)
			"speed":
				player.SPEED += value
			"damage":
				player.damage += value
			"range":
				player.range += value
	
