extends TileMapLayer

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	tile_data.modulate = Palettes.BREWER_VIRIDIS[4]
	return

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true
	
func _on_palette_change():
	#var top: Top = get_tree().root.get_node("Top")
	notify_runtime_tile_data_update()

func _on_ready() -> void:
	notify_runtime_tile_data_update()
