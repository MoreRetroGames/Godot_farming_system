extends KinematicBody

export (int) var speed = 500
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()

var terrainItem = 0
var cropItem = 0

var terrain = null
var crops = null


func _ready():
	
	#Obtener nodos del terreno y de cultivos
	if get_parent() is GridMap:
		terrain=get_parent()
		print(terrain.get_name())
		if terrain.get_child(0) is GridMap:
			crops=terrain.get_child(0)
			print(crops.get_name())
	print("Run...")

func _calculate_gridPosition(val):
	Globals.gridPosition = Vector3(floor(val.x/4),floor(val.y/4),floor(val.z/4))

func _read_terrain():
	_calculate_gridPosition(translation)
	var num = terrain.get_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z)
	return num

func _write_terrain():
	terrain.set_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z,terrainItem,0)

func _read_crops():
	_calculate_gridPosition(translation)
	var num = crops.get_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z)
	return num

func _write_crops():
	crops.set_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z,cropItem,0)
	

func _physics_process(delta):
	
	direction = Vector3(0,0,0)
		
	#Inputs
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	#Move
	direction = direction.normalized()
	direction = direction * speed * delta
	
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	
	#Cell system
	var cell
	
	if Input.is_action_pressed("ui_plow"):
		cell = _read_terrain() 
		if cell <= 1 and cell >= 0:
			terrainItem = cell + 3
			if cell != terrainItem:
				print("Plowing in:") 
				print(Globals.gridPosition)
				print(terrainItem)
				_write_terrain()
	
	if Input.is_action_pressed("ui_fertilize"):
		cell = _read_terrain()
		if cell > 1:
			if cell != terrainItem:
				if cell < 5:
					terrainItem = cell + 1
					print("Fertilizing in:")
					print(Globals.gridPosition)
					print(terrainItem)
					_write_terrain()
				else:
					terrainItem = cell
		
	if Input.is_action_pressed("ui_seed"):
		cell = _read_terrain()
		if cell > 1:
			cell = _read_crops()
			cropItem = 0
			if cell != cropItem:
				print("Seeding in:")
				print(Globals.gridPosition)
				print(cropItem)
				_write_crops()
			
	if Input.is_action_pressed("ui_harvest"):
		cell = _read_crops()
		if cell != -1:
			cropItem = -1
			print("Harvesting in:")
			print(Globals.gridPosition)
			print(cell)
			_write_crops()
			
			cell = _read_terrain()
			if cell > 2:
				terrainItem = cell - 1
				_write_terrain()
	
	if Input.is_action_just_pressed("ui_info"):
		
		cell = _read_terrain()
		print ("Info")
		print (Globals.gridPosition)
		print ("Terrain:")
		print(cell)
		
		cell = _read_crops()
		print ("Crops:")
		print(cell)
		
	
	