extends Node2D

const C = 0.551915024494
const START = "START"
const END = "END"

const CURVE_UP = "CURVE_UP"
const CURVE_DOWN = "CURVE_DOWN"
const LOOP_BACK = "LOOP_BACK"
const STRAIGHT = "STRAIGHT"

const COLOR_IDLE = Color("ffefa0")
#const COLOR_ACTIVE = Color("fca652")
const COLOR_ACTIVE = Color("ac4b1c")

var markers = {}

var points = []
var segments = []

var segment_to_points_idx = {}



class Segment extends Curve2D:
	var type_name:String = ""
	var color:Color = COLOR_IDLE
	
	func _init(name):
		self.type_name = name

	func draw(node:Node2D, offset:Vector2, color:Color, width:float):
		var tesselated_points = self.tessellate()
		var p1 = tesselated_points[0] + offset
		var p2 = Vector2.ZERO
		for idx in range(1, len(tesselated_points)):
			p2 = tesselated_points[idx] + offset
			node.draw_line(p1, p2, color, width, true)
			p1 = p2
		return p2


# Called when the node enters the scene tree for the first time.
func _ready():
	var s = 100
	segments = create_loop(s) 
	segments += create_loop(s * 1.4)
	segments += create_loop(s * .9)
	segments += create_loop(s * .7)
	segments += create_loop(s * .5)
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)
	segments += [straight(500)]
	segments += create_loop(s * .4)


func create_loop(s):
	return [
		straight(s*2),
		curve_up(s),
		loop_back(s),
		curve_down(s),
		straight(s),
	]

func curve_up(s):
	var curve = Segment.new(CURVE_UP)
	var c = C * s
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(c,0))
	curve.add_point(Vector2(s, -s), Vector2(0, c))
	return curve

func straight(s):
	var curve = Segment.new(STRAIGHT)
	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2(s, 0))
	return curve

func loop_back(s):
	var curve = Segment.new(LOOP_BACK)
	var c = C * s
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, -c))
	curve.add_point(Vector2(-s, -s), Vector2(c, 0), Vector2(-c, 0))
	curve.add_point(Vector2(-2*s, 0), Vector2(0, -c))
	return curve

func curve_down(s):
	var curve = Segment.new(CURVE_DOWN)
	var c = C * s
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(0, c))
	curve.add_point(Vector2(s,s), Vector2(-c, 0))
	return curve




func _draw():
	
	var segment_colors = {
		0: Color("ffefa0")
		#1: Color("ffd57e"),
		#2: Color("fca652")
	}
	var offset = Vector2.ZERO	
	var segment_idx = 0
	for segment in segments:
		offset = segment.draw(
			self,
			offset, 
			segment.color, 
			4.0)
		segment_idx += 1
		
