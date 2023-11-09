#############################################################################################################################
# STATE BASE CLASS
# Base class for new state nodes. Should be extended (NOT INSTANTIATED) when creating a new state node.
#############################################################################################################################

class_name State
extends Node


func _enter():
	pass


# Make sure to pass delta when overwriting or calling.
func _loop(delta:float):
	pass


func _exit():
	pass


func _check_for_state_change():
	pass
