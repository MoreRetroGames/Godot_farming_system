extends Control


var text


func _process(delta):
	text = "FPS: "+str(Engine.get_frames_per_second())
	$GUI/Label.text=text

