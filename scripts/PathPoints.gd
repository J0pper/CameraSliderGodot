extends Node2D

var pathPoints: Array[Vector2]
var subjectPoints: Array[Vector2]
var pathPointUpdate: bool = false
@onready var pathPointAmount: int = 0
@onready var subjectPointAmount: int = 0
var pointOffsets: Array[Vector2]

var stdPathColor: Color = Color.CORNFLOWER_BLUE
var hglPathColor: Color = Color.LIGHT_YELLOW
var pathColors: Array[Color]
var subjectColor: Color = Color.CRIMSON

signal sendPathPoints

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
    if len(pathPoints) != pathPointAmount || len(subjectPoints) != subjectPointAmount:
        pathPointUpdate = true
        pathPointAmount = len(pathPoints)
        subjectPointAmount = len(subjectPoints)
    
    var VContainerChildren: Array[Node] = $"../../VContainerPointInfo".get_children()
    if len(VContainerChildren) > 0:
        for child in VContainerChildren:
            var childIndex: int = VContainerChildren.find(child, 0)
            if not child.get_children()[0].button_pressed:
                pathColors[childIndex] = stdPathColor
                continue
            pathColors[childIndex] = hglPathColor
            var mousePos: Vector2 = get_global_mouse_position()
            if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
                pointOffsets[childIndex] = pathPoints[childIndex] - mousePos
                continue
            pathPoints[childIndex] = pointOffsets[childIndex] + mousePos
            child.get_children()[2].text = str(pathPoints[childIndex].x)
            child.get_children()[3].text = str(pathPoints[childIndex].y)
            pathPointUpdate = true
    
    if pathPointUpdate:
        emit_signal("sendPathPoints", pathPoints)
        queue_redraw()
        pathPointUpdate = false


func _draw():
    for point_index in pathPoints.size():
        draw_circle(pathPoints[point_index], 5.0, pathColors[point_index])
    
    for point_index in subjectPoints.size():
        draw_circle(subjectPoints[point_index], 5.0, subjectColor)
    


func _on_camera_arm_created_path_point(arg: Vector2):
    var pathPointRounded: Vector2 = round(arg)
    pathPoints.append(pathPointRounded)
    pointOffsets.append(pathPointRounded)
    pathColors.append(stdPathColor)
    var hContainer: HBoxContainer = HBoxContainer.new()
    var togglePoint: CheckButton = CheckButton.new()
    var pointName: Label = Label.new()
    var coordinateFieldX: Label = Label.new()  # Just a label for now. Would be really cool
    var coordinateFieldY: Label = Label.new()  # if it were an editable field later on.
    
    pointName.text = "Point" + str(len(pathPoints)) + ": "
    coordinateFieldX.text = "x: " + str(pathPointRounded.x)
    coordinateFieldY.text = "y: " + str(pathPointRounded.y)
    
    hContainer.add_child(togglePoint)
    hContainer.add_child(pointName)
    hContainer.add_child(coordinateFieldX)
    hContainer.add_child(coordinateFieldY)
    
    $"../../VContainerPointInfo".add_child(hContainer)


func _on_camera_arm_created_subject_point(arg):
    subjectPoints.append(arg)
