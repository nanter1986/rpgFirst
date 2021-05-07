extends TouchScreenButton

var radius=Vector2(150,150)

func _input(event):
	if event.is_pressed():
		if event.position>radius:
			pass
		else:
			position=event.position
		
		print(event.position)

