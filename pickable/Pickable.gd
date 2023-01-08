extends Area2D
class_name Pickable

signal is_pickable_changed

var _is_pickable := true
var _picker = null

func _ready():
	pass

func set_pickable(flag):
	_is_pickable = flag

func pick_by(node):
	if is_pickable():
		_transfer_to(node)
		_is_pickable = false
		_picker = node
		emit_signal("is_pickable_changed", true)

func drop_on(node):
	if is_picked():
		_transfer_to(node)
		_is_pickable = true
		_picker = null
		emit_signal("is_pickable_changed", false)

func is_picked():
	return _picker != null

func is_pickable():
	return not is_picked() and _is_pickable

func _transfer_to(new_parent):
	get_parent().remove_child(self)
	new_parent.add_child(self)
