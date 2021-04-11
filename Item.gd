extends Node2D

var icon
var item_name
const TYPE="Item"

func init(given_name,x,y):
	position.x=x
	position.y=y
	match given_name:
		"Iron Sword":
			icon = "res://Iron Sword.png"
			item_name="Iron Sword"
		"Tree Branch":
			icon = "res://Tree Branch.png"
			item_name="Tree Branch"

func _ready():
	$TextureRect.texture=load(icon)


func _on_Area2D_body_entered(body):
	pass
	
