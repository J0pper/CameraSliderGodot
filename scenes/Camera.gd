extends ColorRect


func _on_camera_arm_end_effector_posistion(position):
	self.position = position - self.size / 2
