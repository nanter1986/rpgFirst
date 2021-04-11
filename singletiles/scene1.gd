extends Node2D

signal scene_ready(next_scene)
func _ready():
	emit_signal("scene_ready","res://scene2.tscn")


