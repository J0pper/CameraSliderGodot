extends Node2D


var _splineTypes = {
    "Straight Line": _create_straight_line,
    "Quadratic Bezier Spline": _create_quad_bez_spline,
    "Cubic Beizier Spline": _create_cube_bez_spline,
    "Catmul-Rom Spline": _create_cat_rom_spline_chain,
    }

var _splineControlPoints: Array[Vector2]
var _spline: Array[Vector2]
var _splineType: String
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
    _start_spline()

    
func _start_spline():
    if len(_splineType) != 0:
            _splineTypes[_splineType].call()


func _on_option_button_selected_spline_type(selected_spline_type: String):
    print(selected_spline_type)
    _splineType = selected_spline_type


func _create_straight_line():
    _spline = _splineControlPoints
    _update_draw()


func _create_quad_bez_spline():
    # In a quadratic bezier curve between two points; p0 and p2 theres always a
    # third influencing point p1.
    var p0: Vector2
    var p1: Vector2
    var p2: Vector2
    for point in len(_splineControlPoints) - 1:
        p0 = _splineControlPoints[point]
        p2 = _splineControlPoints[point + 1]
        p1 = floor((p2 - p0) + p0)
        for i in range(resolution):
            _spline.append(QuadraticBezierSpline.make_spline(p0, p1, p2, i / resolution))
    _update_draw()


func _create_cube_bez_spline():
    pass


func _create_cat_rom_spline_chain():
    var alpha = 0.5
    var SCP = _splineControlPoints.duplicate() # So the original wont be affected.
    
    var cp0 = SCP[0]
    var cp1 = SCP[1]
    SCP.insert(0, cp0 - (cp1 - cp0))
    
    var cpy = SCP[len(SCP) - 2]
    var cpz = SCP[len(SCP) - 1]
    SCP.append(cpz + (cpz - cpy))
    
    var nSegments = len(SCP) - 3
    var P = SCP
    for i in range(nSegments):
        var segment = CatmulRomSpline.make_spline(P[i], P[i + 1], P[i + 2], P[i + 3], resolution, alpha)
        for point in segment:
            _spline.append(point)
    
    _update_draw()
