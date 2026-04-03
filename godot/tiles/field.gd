@tool
extends Node2D

@export var hex_size: int = 20

@export var show_debug: bool = true:
	set(value):
		show_debug = value
		queue_redraw()
@export var debug_size: int = 2


# hex to screen
var h2s := Transform2D(
	Vector2( 2,      0 ),
	Vector2( 1, sqrt(3)),
	Vector2( 0,      0 )
) * hex_size / 2

# screen to hex
var s2h := h2s.affine_inverse()


func hex_in_bound(bound: Rect2):
	var r_limits = [] # the rows in the corners will enclose the range
	for c in 4:
		var ss = bound.get_support(Vector2.ONE.rotated(c * PI/2))
		var sh = s2h * ss
		r_limits.append((ss.y - h2s.x.y * sh.x) / h2s.y.y)

	return range(
		ceili(r_limits.min()),
		floori(r_limits.max()) + 1
		).map(func(r):
			var q_limits = [bound.position, bound.end].map(func(v):
				return (v.x - h2s.y.x * r) / h2s.x.x)
			return range(
				ceili(q_limits.min()),
				floori(q_limits.max()) + 1
				).map(func(q):
					return Vector2(q,r)))


func _draw():
	if not show_debug: return

	for row in hex_in_bound(get_viewport().get_visible_rect()):
		for h in row:
			draw_circle(h2s * h, debug_size, Color.AQUA)

func _process(_d):
	if show_debug: queue_redraw()
