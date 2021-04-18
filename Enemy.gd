extends KinematicBody2D

export(int) var SPEED=100
export(int) var FRICTION=300
export(int) var ACCELERATION=200
export(float) var scale_factor=0.5

onready var animation_player=$AnimationPlayer
onready var animation_tree=$AnimationTree
var velocity=Vector2()
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
	return Vector2(rand_range(-1, 1), rand_range(-1, 1))

func set_animation_tree_parameters(input_vector):
	animation_tree.set("parameters/Idle/blend_position",input_vector)
	animation_tree.set("parameters/Move/blend_position",input_vector)

func move_state(delta):
	var input_vector=get_random_vector()
	print(str(input_vector))
	if input_vector != Vector2.ZERO:
		set_animation_tree_parameters(input_vector)
		state_machine.travel("move")
		velocity=velocity.move_toward(input_vector*SPEED,delta*ACCELERATION)
	else:
		state_machine.travel("idle")
		velocity=velocity.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = move_and_slide(velocity)
