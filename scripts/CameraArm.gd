extends Node2D

@onready var start = get_viewport_rect().size / 2
@onready var cameraArmPolar: Vector2
@onready var cameraArmPolarReference: Vector2 = cameraArmPolar
signal createdPathPoint
signal createdSubjectPoint
signal endEffectorPosistion


func _process(delta):
	if cameraArmPolar != cameraArmPolarReference:
		queue_redraw()
		cameraArmPolarReference = cameraArmPolar
		emit_signal("endEffectorPosistion", cameraArmPolar)


func _draw():
	var end: Vector2 = _center(_polar2cartesian(cameraArmPolar))
	draw_line(start, end, Color.WHITE, 4.0, true)
	emit_signal("endEffectorPosistion", end)
	

func _polar2cartesian(polar_vec: Vector2):
	# print(polar_vec[1], " ", deg_to_rad(polar_vec[1]), " ", cos(deg_to_rad(polar_vec[1])))
	return Vector2(cos(deg_to_rad(polar_vec[1])) * polar_vec[0], sin(deg_to_rad(polar_vec[1])) * polar_vec[0])


func _center(vec: Vector2):
	return vec + get_viewport_rect().size / 2
	
	
func _on_add_track_point_pressed():
	emit_signal("createdPathPoint", _center(_polar2cartesian(cameraArmPolar)))


func _on_add_subject_point_pressed():
	emit_signal("createdSubjectPoint", _center(_polar2cartesian(cameraArmPolar)))	


func _on_h_slider_length_camera_arm_length(length):
	cameraArmPolar[0] = length


func _on_h_slider_angle_camera_arm_angle(angle):
	cameraArmPolar[1] = angle
