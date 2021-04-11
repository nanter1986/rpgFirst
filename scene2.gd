extends Node2D

signal scene_ready(next_scene)
var itemScene = preload("Item.tscn")

func _ready():
	emit_signal("scene_ready","res://scene1.tscn")
	var instacedItemScene1= itemScene.instance()
	instacedItemScene1.init("Tree Branch",250,100)
	add_child(instacedItemScene1)
	
	var instacedItemScene2= itemScene.instance()
	instacedItemScene2.init("Iron Sword",250,50)
	add_child(instacedItemScene2)
	
	var instacedItemScene3= itemScene.instance()
	instacedItemScene3.init("Iron Sword",200,50)
	add_child(instacedItemScene3)
