extends Spatial

export var tile_size := 2.2
export (int, 1, 20) var grid_size := 5

var hexagon_tile = preload("res://scenes/obstacles/hexagon/tile.tscn")

func _ready() -> void:
	generate()

func generate():
	for x in range(grid_size):
		var tile_coordinates := Vector2.ZERO
		tile_coordinates.x = x * tile_size * cos(deg2rad(30))
		tile_coordinates.y = 0.0 if x % 2 == 0 else tile_size / 2
		for _y in range(grid_size):
			var tile = hexagon_tile.instance()
			add_child(tile)
			tile.translate(Vector3(tile_coordinates.x, 0, tile_coordinates.y))
			tile_coordinates.y += tile_size
