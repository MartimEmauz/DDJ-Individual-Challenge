extends CanvasLayer

signal select_powerup(power : String, value : float)

func _ready() -> void:
	#debug
	print("Choosing power-up...")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked at: ", event.position)

	
func _on_health_pressed() -> void:
	print("pressed health")
	select_powerup.emit("health", 10)
	queue_free()

func _on_speed_pressed() -> void:
	select_powerup.emit("speed", 10)
	queue_free()

func _on_damage_pressed() -> void:
	select_powerup.emit("damage", 5)
	queue_free()

func _on_range_pressed() -> void:
	select_powerup.emit("range", 10)
	queue_free()
