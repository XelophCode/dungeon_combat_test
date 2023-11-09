@tool
extends Label3D

# Gives better precision over 'pixel_size' slider. Lower values = higher quality text.
@export_range(0.0001,0.005,0.0001) var precise_pixel_size : float:
	set(value):
		pixel_size = value
		precise_pixel_size = value
