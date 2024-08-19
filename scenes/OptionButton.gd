extends OptionButton

var _splineTypes: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_splines_emit_spline_types(spline_types):
	_splineTypes = spline_types
	var splineId: int = 1
	for spline in _splineTypes.keys():
		self.add_item(spline, splineId)
		self.set_item_metadata(splineId, _splineTypes[spline])
		splineId += 1
	self.select(0)


func _on_calculate_camera_path_pressed():
	if self.get_selected_metadata() == null:
		return
	self.get_selected_metadata().call()
	# emit_signal("selectedSplineType", self.get_selected_metadata())
