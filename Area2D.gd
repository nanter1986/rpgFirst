extends Node2D

const TYPE="Portal"
export(String,FILE) var next_scene=""

func _on_Area2D_body_entered(body):
	if get_tree().change_scene(next_scene)!=OK:
		print("no scene")
