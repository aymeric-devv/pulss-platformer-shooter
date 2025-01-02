extends Node2D

@export var player : CharacterBody2D

func _on_autojump_button_down() -> void:
	$Player.auto_jump = !$Player.auto_jump 
	print("changed")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rocket_cat.tscn")
