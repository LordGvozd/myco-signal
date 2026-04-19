class_name Spectrogramma extends Control


@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0

# Массив точек в локальных координатах Control
var points: PackedVector2Array = []

func _ready():
	points = [
		Vector2(0, 500),
		Vector2(50, 20),
		Vector2(100, 80),
		Vector2(150, 10),
		Vector2(200, 120),
		Vector2(250, 30),
		Vector2(300, 90)
	]
	queue_redraw()

func _draw():
	if points.size() < 2:
		return
	
	draw_polyline(points, line_color, line_width, true)  # true = антиалиасинг

func add_point(pos: Vector2):

	pos.y = size.y - pos.y
	points.append(pos)
	
	queue_redraw()

func clear_points():
	points.clear()
	queue_redraw()
