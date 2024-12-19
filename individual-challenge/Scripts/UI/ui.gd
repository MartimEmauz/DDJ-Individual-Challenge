extends CanvasLayer

@onready var level_label: Label = $Level
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	level_label.text = "Level: " + str(player.level)
	
	player.level_up.connect(_on_level_up)

func _on_level_up(level: int):
	level_label.text = "Level: " + str(level)
