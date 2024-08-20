extends OptionButton

var _splineTypes: Dictionary

signal selectedSplineType

func _on_splines_emit_spline_types(spline_types):
	_splineTypes = spline_types
	var splineId: int = 1
	for spline in _splineTypes.keys():
		self.add_item(spline, splineId)
		self.set_item_metadata(splineId, spline)
		splineId += 1
	self.select(0)


func _on_calculate_camera_path_pressed():
	if self.get_selected_metadata() == null:
		return
	self.get_selected_metadata().call()
	# emit_signal("selectedSplineType", self.get_selected_metadata())


func _on_item_selected(index):
	var itemMetaData = self.get_selected_metadata()
	if itemMetaData == null:
		return
	emit_signal("selectedSplineType", itemMetaData)
