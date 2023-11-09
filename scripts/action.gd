#############################################################################################################################
# ACTION BASE CLASS
# Base class for new action nodes. Should be extended (NOT INSTANTIATED) when creating a new action node.
#############################################################################################################################


class_name Action
extends Node


# Make sure to pass delta when overwriting or calling.
func _action(delta:float):
	pass
