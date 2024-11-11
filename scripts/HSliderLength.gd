extends HSlider

signal cameraArmLength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    $Value.text = str(self.value)
    emit_signal("cameraArmLength", self.value)
