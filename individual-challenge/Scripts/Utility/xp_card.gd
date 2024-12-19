extends Area2D

signal collect_xp(amount)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	connect("collect_xp", player._on_collect_xp)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hit_boxes"):
		print('collected xp')
		collect_xp.emit(10)
		queue_free()
