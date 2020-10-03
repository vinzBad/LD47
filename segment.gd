extends Node2D
class_name Segment

const CURVE_RIGHT_UP = "CURVE_RIGHT_UP"
const CURVE_DOWN_RIGHT = "CURVE_DOWN_RIGHT"
const CURVE_UP_LEFT = "CURVE_UP_LEFT"
const CURVE_LEFT_DOWN = "CURVE_LEFT_DOWN"
const LOOP_BACK = "LOOP_BACK"
const STRAIGHT = "STRAIGHT"

const COLOR_IDLE = Color("ffefa0")
#const COLOR_ACTIVE = Color("fca652")
const COLOR_ACTIVE = Color("ac4b1c")

var type_name:String = ""
var color:Color = COLOR_IDLE setget set_color, get_color
var curve:Curve2D = Curve2D.new()
var __tesselated_points
var width = 24

var next_segment
var prev_segment


# mock Curve2D - start
func add_point (position:Vector2, in_control:Vector2=Vector2( 0, 0 ),  out_control:Vector2=Vector2( 0, 0 ), at_position:int=-1 ):
	curve.add_point(position, in_control, out_control, at_position)
	
func tessellate():
	__tesselated_points = curve.tessellate()
	return __tesselated_points

func get_baked_length():
	return curve.get_baked_length()

func interpolate_baked(offset:float, cubic:bool=false):
	return curve.interpolate_baked(offset, cubic)
# mock Curve2D - end

func set_color(value:Color):
	color = value
	update()

func get_color():
	return color

func last_point():
	if not __tesselated_points:
		__tesselated_points = tessellate()
	return __tesselated_points[len(__tesselated_points) - 1]


func _draw():
	tessellate()
	var p1 = __tesselated_points[0] 
	var p2 = Vector2.ZERO

	for idx in range(1, len(__tesselated_points)):
		p2 = __tesselated_points[idx] 
		var t = curve.get_closest_offset(p2) / curve.get_baked_length()
		draw_line(p1, p2, color, width, true)
		p1 = p2
	
