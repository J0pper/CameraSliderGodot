extends Node2D


var _splineTypes = {
	"Straight Line": _create_straight_line,
	"Quadratic Bezier Spline": _create_quad_bez_spline,
	"Cubic Beizier Spline": _create_cube_bez_spline,
	"Catmul-Rom Spline": _create_cat_rom_spline_chain,
	}

var _splineControlPoints: Array[Vector2]
var _spline: Array[Vector2]
var resolution: int = 1000

signal emitSplineTypes


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("emitSplineTypes", _splineTypes)


func _draw():
	for point in len(_spline) - 1:
		draw_line(_spline[point], _spline[point + 1], Color.RED, 1.0, true)


func _update_draw():
	queue_redraw()


func _on_path_points_send_path_points(path_points: Array[Vector2]):
	_spline.clear()
	_splineControlPoints = path_points.duplicate()


func _create_straight_line():
	_spline = _splineControlPoints
	_update_draw()


func _create_quad_bez_spline():
	# In a quadratic bezier curve between two points; p0 and p2 theres always a
	# third influencing point p1.
	var p1: Array[Vector2]
	for point in len(_splineControlPoints) - 1:
		var p0: Vector2 = _splineControlPoints[point]
		var p2: Vector2 = _splineControlPoints[point + 1]
		p1.append(floor((p2 - p0) / 2 + p0))
	_spline = _splineControlPoints
	for point in p1:
		_spline.append(point)
	_update_draw()


func _create_cube_bez_spline():
	pass


func _create_cat_rom_spline_chain():
	var alpha = 0.5
	var resolution = 50
	
	var cp0 = _splineControlPoints[0]
	var cp1 = _splineControlPoints[1]
	_splineControlPoints.insert(0, cp0 - (cp1 - cp0))
	
	var cpy = _splineControlPoints[len(_splineControlPoints) - 2]
	var cpz = _splineControlPoints[len(_splineControlPoints) - 1]
	_splineControlPoints.append(cpz + (cpz - cpy))
	
	var nSegments = len(_splineControlPoints) - 3
	var P = _splineControlPoints
	for i in range(nSegments):
		var segment = _cat_rom_spline.call(P[i], P[i + 1], P[i + 2], P[i + 3], resolution, alpha)
		for point in segment:
			_spline.append(point)
	
	_update_draw()


func _cat_rom_spline(p0, p1, p2, p3, resolution, alpha):
	
	var tj = func tj(ti: float, pi: Vector2, pj: Vector2):
		return pow(pj.distance_to(pi), alpha) + ti
	
	var t0 = 0.0
	var t1 = tj.call(t0, p0, p1)
	var t2 = tj.call(t1, p1, p2)
	var t3 = tj.call(t2, p2, p3)
	
	var step = (t2 - t1) / (resolution - 1)
	var curve: Array[Vector2]
	
	for i in range(resolution - 1):
		var t = t1 + i * step
		
		var a1 = (t1 - t) / (t1 - t0) * p0 + (t - t0) / (t1 - t0) * p1
		var a2 = (t2 - t) / (t2 - t1) * p1 + (t - t1) / (t2 - t1) * p2
		var a3 = (t3 - t) / (t3 - t2) * p2 + (t - t2) / (t3 - t2) * p3
		
		var b1 = (t2 - t) / (t2 - t0) * a1 + (t - t0) / (t2 - t0) * a2
		var b2 = (t3 - t) / (t3 - t1) * a2 + (t - t1) / (t3 - t1) * a3
		
		var c = (t2 - t) / (t2 - t1) * b1 + (t - t1) / (t2 - t1) * b2
		curve.append(c)
	return curve
