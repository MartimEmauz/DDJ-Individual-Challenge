extends Node

@export var hp : float = 100
@export var max_hp : float = 100
@export var health_bar : TextureProgressBar

signal die

var is_dead = false

func _ready() -> void:
	if health_bar:
		health_bar.value = hp
		health_bar.max_value = max_hp

func take_damage(damage : int):
	hp = clamp(hp - damage, 0, max_hp)
	
	if health_bar != null:
		health_bar.value = hp
	
	if hp <= 0 and !is_dead:
		die.emit()
		is_dead = true
		
func _on_player_increase_health(value: float) -> void:
	max_hp += value
	print("new max hp", max_hp)
	health_bar.max_value += max_hp
