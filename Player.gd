extends KinematicBody2D

export(int) var SPEED=100
export(int) var FRICTION=300
export(int) var ACCELERATION=200
export(float) var scale_factor=0.5

onready var animPlayer=$AnimationPlayer
onready var anim_tree=$AnimationTree
onready var hotbar=$Hotbar
onready var state_machine
onready var tilemap=get_parent().find_node("TileMap")
var velocity=Vector2()
var itemScene = preload("Item.tscn")
var items_collected={
	"1":"empty",
	"2":"empty",
	"3":"empty",
	"4":"empty",
	"5":"empty",
	"6":"empty",
	"7":"empty",
	"8":"empty",
	"9":"empty",
	"10":"empty"
}
var inventory_file = "user://inventory.save"

func _ready():
	state_machine= anim_tree.get("parameters/playback")
	print(state_machine)
	anim_tree.active=true
	state_machine.start("Move")
	self.scale.x*=scale_factor
	self.scale.y*=scale_factor
	load_inventory()


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
		tilemap.set_cell(tilePosition.x+1,tilePosition.y,0)
		item.queue_free()
		items_collected[str(position)]="empty"
	else:
		print("slot is empty")
		
func get_direction_the_player_is_facing():
	pass
	
func add_tile_to_where_player_is_facing():
	pass
	
func save_inventory():
	var file = File.new()
	var items_to_save={}
	for i in range(1,11):
		items_to_save[str(i)]=items_collected[str(i)]
	file.open(inventory_file, File.WRITE)
	file.store_var(items_to_save, true)
	print("saved items")
	file.close()
	print(items_to_save)
	
func load_inventory():
	var file = File.new()
	var items_to_load
	if file.file_exists(inventory_file):
		var error = file.open(inventory_file, File.READ)
		if error == OK:
			items_to_load = file.get_var(true)
			print("items to load:")
			print(items_to_load)
			file.close()
			print("a")
			print("inventory to be loaded")
			print(items_to_load)
			if items_to_load!=null:
				for counter in range(1,11):
					if items_to_load.get(str(counter),"empty")=="empty":
						items_collected[str(counter)]=items_to_load.get(str(counter),"empty")
						print("was empty")
					else:
						var current_item=items_to_load.get(str(counter),"empty")
						print(current_item)
						items_collected[str(counter)]=current_item
						var loaded_item_instance= itemScene.instance()
						loaded_item_instance.init(current_item,10,10)
						print("about to add "+current_item+"in position "+str(counter))
						find_node("Hotbar").find_node("HBoxContainer").find_node("Panel"+str(counter)).add_child(loaded_item_instance)
					
	print("inventory loaded")
	print(items_collected)
	
	
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
	
func loop_through_dictionary_and_find_empty_spot():
	var spot=0
	for i in range(1,11):
		print("iteration:"+str(i))
		print(items_collected)
		if items_collected[str(i)]=="empty":
			spot=i
			print("detected free spot")
			break
	return spot
		
	
func add_item_to_array_and_hotbar(item):
	var open_hotbar_spot=loop_through_dictionary_and_find_empty_spot()
	print("open hotbar spot:"+str(open_hotbar_spot))
	if open_hotbar_spot!=0:
		items_collected[str(open_hotbar_spot)]=item.item_name
		print("item:"+str(item.item_name))
		find_node("Hotbar").find_node("HBoxContainer").get_child(open_hotbar_spot-1).add_child(item)
		print(items_collected)

func _on_ItemDetection_area_entered(area):
	var parent_type=get_item_type_and_remove(area)
	print("parent of entered:"+parent_type)
	if parent_type=="Item":
		var item=create_the_item_to_be_added(area)
		add_item_to_array_and_hotbar(item)
	elif parent_type=="Portal":
		save_inventory()
		var the_next_scene=area.get_parent().next_scene
		print(the_next_scene)
# warning-ignore:return_value_discarded
		get_tree().change_scene(the_next_scene)
	
