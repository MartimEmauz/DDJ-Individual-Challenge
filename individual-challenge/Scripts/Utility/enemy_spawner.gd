extends Marker2D
class_name EnemySpawner

@export var enemy_scene : PackedScene
@export var spawner_texture: Texture2D

var is_spawning = false

func _ready() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = spawner_texture
	add_child(sprite)
	sprite.position = Vector2(0, 0)
	
	var timer = Timer.new()
	add_child(timer)
	
	var spawn_time = (randi() % 11 + 5)
	print(spawn_time)
	
	timer.wait_time = spawn_time
	timer.start()
	
	timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	if is_spawning:
		return
	
	is_spawning = true
	var new_enemy = enemy_scene.instantiate()
	owner.add_child(new_enemy)
	
	new_enemy.global_position = global_position + Vector2(0, -25)
	
	is_spawning = false
