extends Node2D

@export var show_debug: bool = true:
	set(value):
		show_debug = value
		queue_redraw()

@export var hex_size: int = 20

# hex to screen
var h2s = Transform2D(
	Vector2( 2,      0 ),
	Vector2( 1, sqrt(3)),
	Vector2( 0,      0 )
) * hex_size / 2

# screen to hex
var s2h = h2s.affine_inverse()

var debug := Label.new()
func _init():
	add_child(debug)
	debug.set_position(Vector2(10,10))

func _draw():
	if not show_debug:
		return

	var vw = s2h * get_viewport().get_visible_rect()
	for q in range(vw.position.x, ceil(vw.end.x)):
		for r in range(vw.position.y, ceil(vw.end.y)):
			var centre = h2s * Vector2(q,r)
			draw_circle(centre, 10, Color.AQUA, false)
			
func _process(_d):


	var mouse_pos = get_viewport().get_mouse_position()
	debug.text = "mouse %f, %f\nhex %f, %f" % [
		mouse_pos.x,
		mouse_pos.y,
		(s2h * mouse_pos).x,
		(s2h * mouse_pos).y
	]
	queue_redraw()
