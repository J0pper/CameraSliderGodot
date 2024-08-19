extends HSlider

signal cameraArmAngle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Value.text = str(self.value)
	emit_signal("cameraArmAngle", self.value)
