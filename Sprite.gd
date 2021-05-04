extends TouchScreenButton

var radius=Vector2(50,50)
var boundary

var ongoing_drag=-1

var return_accel=20

var threshold=10

func _process(delta):
	if ongoing_drag==-1:
		print("ongoing drag==-1")
		var pos_difference=(Vector2(0,0)-radius)-position
		print("pos diff "+str(pos_difference))
		print("radius "+str(radius))
		position+=pos_difference*return_accel*delta*global_scale
		print("position")
		print(position)
		

func _ready():
	boundary=160
	print("boundary:")
	print(boundary)

func get_button_position():
	return position+radius

func _input(event):
	print("global scale")
	print(global_scale)
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		print("first if")
		var event_dist_from_center=(event.position-get_parent().global_position).length()
		
		if event_dist_from_center<=boundary*global_scale.x or event.get_index()==ongoing_drag:
			print("second if")
			set_global_position(event.position-radius*global_scale)
			if get_button_position().length()> boundary:
				print("third if")
				set_position(get_button_position().normalized()*boundary-radius)
			ongoing_drag=event.get_index()
		
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index()==ongoing_drag:
		print("setting to -1")
		ongoing_drag=-1
		
		
func get_value():
	if get_button_position().length()>threshold:
		return get_button_position().normalized()
	return Vector2(0,0)
