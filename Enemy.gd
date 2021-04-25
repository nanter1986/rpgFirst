extends KinematicBody2D

export(int) var SPEED=100
export(int) var FRICTION=300
export(int) var ACCELERATION=200
export(float) var scale_factor=0.5
export(int) var delay_to_change_direction=1000

onready var animation_player=$AnimationPlayer
onready var animation_tree=$AnimationTree
var velocity=Vector2()
var input_vector=Vector2(rand_range(-1, 1), rand_range(-1, 1))
var time_left_to_switch_direction=delay_to_change_direction
onready var state_machine
enum direction{
	LEFT,
	RIGHT
}

enum action{
	IDLE,
	MOVE,
	ATTACK
}

var action_state
var direction_state

func _ready():
	randomize()
	state_machine= animation_tree.get("parameters/playback")
	direction_state=direction.LEFT
	action_state=action.IDLE
	self.scale.x*=scale_factor
	self.scale.y*=scale_factor
	animation_player.play("idle_left")

func _physics_process(delta):
	move_state(delta)
	match direction_state:
		direction.LEFT:
			animation_player.play("idle_left")
		direction.RIGHT:
			animation_player.play("idle_right")

func get_random_vector():
	var the_vector=Vector2()
	if rand_range(0,1)==0:
		the_vector=Vector2(rand_range(-1, 1), rand_range(-1, 1))
		print("enemy moving")
	else:
		the_vector=Vector2.ZERO
		print("enemy standing")
	return the_vector

func set_animation_tree_parameters(input_vector):
	animation_tree.set("parameters/Idle/blend_position",input_vector)
	animation_tree.set("parameters/Move/blend_position",input_vector)

func move_state(delta):
	time_left_to_switch_direction-=1
	if time_left_to_switch_direction<0:
		input_vector=get_random_vector()
		time_left_to_switch_direction=delay_to_change_direction
		print(str(input_vector))
	if input_vector != Vector2.ZERO:
		set_animation_tree_parameters(input_vector)
		state_machine.travel("move")
		velocity=velocity.move_toward(input_vector*SPEED,delta*ACCELERATION)
	else:
		state_machine.travel("idle")
		velocity=velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = move_and_slide(velocity)
