@tool
extends CSGCombiner3D


# Properties
@export_category("Stairs Config")
@export var stairs_amount: int = 1 : set = stairs_amount_set, get = stairs_amount_get
@export var stairs_width: float = 2.0 : set = stairs_width_set, get = stairs_width_get
@export var stair_height: float = 0.15 : set = stair_height_set, get = stair_height_get
@export var stair_depth: float = 0.3 : set = stair_depth_set, get = stair_depth_get
@export var material: Material = null : set = material_set, get = material_get

# Internal variables
var stairs = []


# stairs_amount setter/getter
func stairs_amount_set(new_amount):
	stairs_amount = new_amount if new_amount >= 1 else stairs_amount
	reset_stairs()


func stairs_amount_get():
	return stairs_amount


# stairs_width setter/getter
func stairs_width_set(new_width):
	stairs_width = new_width if new_width > 0.1 else stairs_width
	adjust_stairs_width()


func stairs_width_get():
	return stairs_width


# stair_height setter/getter
func stair_height_set(new_height):
	stair_height = new_height if new_height > 0.05 else stair_height
	adjust_stairs_height()
	adjust_stairs_y_positions()


func stair_height_get():
	return stair_height


# stair_depth setter/getter
func stair_depth_set(new_depth):
	stair_depth = new_depth if new_depth > 0.05 else stair_depth
	adjust_stairs_depth()
	adjust_stairs_z_positions()


func stair_depth_get():
	return stair_depth


# material setter/getter
func material_set(new_material: Material):
	material = new_material
	adjust_stairs_materials()


func material_get():
	return material


# Called when the node enters the scene tree for the first time.
func _init():
	if Engine.is_editor_hint():
		delete_all_stairs()
		delete_all_child_nodes() # boop
	reset_stairs()


# Creating & destroying stairs
func create_new_stair():
	var new_stair = CSGBox3D.new()
	new_stair.name = "Stair{index}".format({"index": stairs.size() + 1})
	new_stair.material = material
	self.add_child(new_stair)
	new_stair.set_owner(self)
	stairs.append(new_stair)
	new_stair.transform = self.transform
	
	if stairs.size() > 1:
		new_stair.rotation = stairs.front().rotation

func delete_last_stair():
	stairs.back().queue_free()
	stairs.resize(stairs.size() - 1)


func delete_all_stairs():
	while stairs.size() > 0:
		delete_last_stair()


func delete_all_child_nodes():
	for child in self.get_children():
		child.queue_free()

# Setting stair properties
func adjust_stairs_width():
	for stair in stairs:
		stair.width = stairs_width

func adjust_stairs_depth():
	for stair in stairs:
		stair.depth = stair_depth


func adjust_stairs_height():
	for stair in stairs:
		stair.height = stair_height


func adjust_stairs_y_positions():
	for i in range(0, stairs.size()):
		var new_y_pos = (stair_height / 2) + (i * stair_height)
		stairs[i].position.y = new_y_pos


func adjust_stairs_z_positions():
	for i in range(0, stairs.size()):
		var new_z_pos = 0
		new_z_pos -= (stairs.size() - (i + 1)) * stair_depth
		stairs[i].position.z = new_z_pos


func adjust_stairs_x_positions():
	for i in range(0, stairs.size()):
		var new_x_pos = 0
		stairs[i].position.x = new_x_pos


func adjust_stairs_dimensions():
	adjust_stairs_width()
	adjust_stairs_depth()
	adjust_stairs_height()


func adjust_stairs_positions():
	adjust_stairs_y_positions()
	adjust_stairs_z_positions()
	adjust_stairs_x_positions()

func adjust_stairs_materials():
	for stair in stairs:
		stair.material = material


func reset_stairs():
	var previous_size = stairs.size()
	if stairs.size() > stairs_amount:
		while stairs.size() > stairs_amount:
			delete_last_stair()
			
	elif stairs.size() < stairs_amount:
		while stairs.size() < stairs_amount:
			create_new_stair()
	
	if previous_size != stairs.size():
		adjust_stairs_dimensions()
		adjust_stairs_positions()
