extends Node

var game_scene = ("res://Scenes/game.tscn")
var menu_scene = ("res://Scenes/UI/menu.tscn")

func go_to_menu():
	get_tree().change_scene_to_file(menu_scene)
	
func go_to_play():
	get_tree().change_scene_to_file(game_scene)
