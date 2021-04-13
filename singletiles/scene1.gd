extends Node2D

signal scene_ready(next_scene)
onready var tileset=$TileMap.tile_set

func _ready():
	print(str(tileset.get_tiles_ids()))
	tileset.remove_tile(4)
	emit_signal("scene_ready","res://scene2.tscn")


