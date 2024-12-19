extends Area2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $DisableTimer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var slime: CharacterBody2D = $".."

signal hurt(damage)

func suffer_attack(damage : int):
	hurt.emit(damage)
	
	collider.call_deferred("set", "disabled", true)
	
	timer.start()

func _on_disable_timer_timeout() -> void:
	collider.call_deferred("set", "disabled", false)

func _on_player_attack(damage: Variant, range : Variant) -> void:
	var distance = (slime.position-player.position).length()
	
	if distance < range:
		suffer_attack(damage)
