extends TouchScreenButton

var radius=Vector2(150,150)
var positionCurrent=Vector2(0,0)

func _physics_process(delta):
	position=positionCurrent

func _input(event):
	if event.is_pressed():
		if event.position>radius:
			pass
		else:
			positionCurrent=event.position
		
		print(event.position)

