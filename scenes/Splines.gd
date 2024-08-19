extends Node2D


var _splineTypes = {
	"Straight Line": _cr8_straight_line,
	"Quadratic Bezier Spline": _begin_spline,
	"Cubic Beizier Spline": _begin_spline,
	"Catmul-Rom Spline": _begin_spline
	}

var _splineType: String
var _splinePoints: Array[Vector2]
var _spline: Array[Vector2]
var resolution: int = 1000

signal emitSplineTypes
signal requestSplinePoints

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("emitSplineTypes", _splineTypes)

func _draw():
	print("hello ")
	print(_spline)
	draw_line(Vector2(0, 0), Vector2(100, 100), Color.RED, 1, true)
	for point in len(_spline) - 1:
		draw_line(_spline[point], _spline[point + 1], Color.RED, 1.0, true)

func _begin_spline(spline_type):
	_splineType = spline_type
	
	
func _on_path_points_send_path_points(path_points: Array[Vector2]):
	_splinePoints = path_points

func _cr8_straight_line():
	_spline = _splinePoints
	_update_draw()

func _create_quad_bez_spline():
	pass

func _create_cube_bez_spline():
	pass

func _create_cat_rom_spline():
	pass

func _update_draw():
	queue_redraw()
