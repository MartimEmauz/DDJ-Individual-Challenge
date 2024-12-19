extends CanvasLayer

@onready var xp_label: Label = $"Xp amount"
@onready var level_label: Label = $Level
@onready var player: CharacterBody2D = $"../Player"


func _ready() -> void:
	level_label.text = "Level: " + str(player.level)
	xp_label.text = str(player.total_xp) + " xp"
	
	player.level_up.connect(_on_level_up)
	player.collect_xp.connect(_on_collect_xp)

func _on_level_up(level: int):
	level_label.text = "Level: " + str(level)
	xp_label.text = str(0) + " xp"
	
func _on_collect_xp(amount):
	xp_label.text = str(player.total_xp) + " xp"
