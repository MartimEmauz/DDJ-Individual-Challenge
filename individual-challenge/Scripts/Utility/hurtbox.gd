extends Area2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $DisableTimer

signal hurt(damage)

func suffer_attack(damage : int):
	hurt.emit(damage)
	
	collider.call_deferred("set", "disabled", true)
	
	timer.start()
	
func _on_disable_timer_timeout() -> void:
	collider.call_deferred("set", "disabled", false)


func _on_slime_attack(damage: Variant) -> void:
	suffer_attack(damage)
