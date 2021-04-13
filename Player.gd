extends KinematicBody2D

export(int) var SPEED=100
export(int) var FRICTION=300
export(int) var ACCELERATION=200
export(float) var scale_factor=0.5

onready var animPlayer=$AnimationPlayer
onready var anim_tree=$AnimationTree
onready var state_machine
onready var tilemap=get_parent().find_node("TileMap")
var velocity=Vector2()
var itemScene = preload("Item.tscn")
var items_collected=[]

func _ready():
	state_machine= anim_tree.get("parameters/playback")
	print(state_machine)
	anim_tree.active=true
	state_machine.start("Move")
	self.scale.x*=scale_factor
	self.scale.y*=scale_factor


func move_state(delta):
	var input_vector=get_input()
	
	if input_vector != Vector2.ZERO:
		set_animation_tree_parameters(input_vector)
		state_machine.travel("Move")
		velocity=velocity.move_toward(input_vector*SPEED,delta*ACCELERATION)
	else:
		state_machine.travel("Idle")
		velocity=velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	
	velocity = move_and_slide(velocity)
	#print(state_machine)

func set_animation_tree_parameters(input_vector):
	anim_tree.set("parameters/Idle/blend_position",input_vector)
	anim_tree.set("parameters/Move/blend_position",input_vector)
	
func _physics_process(delta):
	get_input()
	move_state(delta)
	
func use_item(position):
	if find_node("Hotbar").find_node("Control").find_node("HBoxContainer").find_node("Panel"+position).get_child(0) != null:
		var item=find_node("Hotbar").find_node("Control").find_node("HBoxContainer").find_node("Panel"+position).get_child(0)
		print(item.item_name)
		var tilePosition=tilemap.world_to_map(self.position)
		print(str(tilePosition))
		tilemap.set_cell(tilePosition.x,tilePosition.y,0)
		item.queue_free()
	else:
		print("slot is empty")
	
	
func get_input():
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector=input_vector.normalized()
	if Input.is_action_just_pressed("hotbar1"):
		use_item("1")
	if Input.is_action_just_pressed("hotbar2"):
		use_item("2")
	if Input.is_action_just_pressed("hotbar3"):
		use_item("3")
	#print("input vector:"+str(input_vector))
	return input_vector

func get_item_type_and_remove(area):
	print("the area"+str(area.get_parent()))
	var parent=area.get_parent()
	var parent_type=parent.TYPE
	parent.queue_free()
	return parent_type

func create_the_item_to_be_added(area):
	var item=area.get_parent()
	print(item)
	print(item.icon)
	print(item.item_name)
	var instacedItemScene= itemScene.instance()
	instacedItemScene.init(item.item_name,10,10)
	print("to add:"+instacedItemScene.item_name)
	return instacedItemScene
	
func add_item_to_array_and_hotbar(item):
	var size_of_items_array=items_collected.size()
	items_collected.append(item)
	print("item:"+str(item.item_name))
	find_node("Hotbar").find_node("HBoxContainer").get_child(size_of_items_array).add_child(item)

func _on_ItemDetection_area_entered(area):
	var parent_type=get_item_type_and_remove(area)
	print("parent of entered:"+parent_type)
	if parent_type=="Item":
		var item=create_the_item_to_be_added(area)
		add_item_to_array_and_hotbar(item)
	elif parent_type=="Portal":
		var the_next_scene=area.get_parent().next_scene
		print(the_next_scene)
# warning-ignore:return_value_discarded
		get_tree().change_scene(the_next_scene)
	
