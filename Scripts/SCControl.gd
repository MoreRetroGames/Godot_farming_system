extends Control

export (int) var timeMul = 5

var soilItem = 0
var cropItem = 0

var soil = null
var crops = null

func _ready():
	#Inicializar temporizadores
	$SoilTimer.wait_time = $SoilTimer.wait_time * timeMul
	$GrassTimer.wait_time = $GrassTimer.wait_time * timeMul
	$SoilTimer.start()
	$GrassTimer.start()
	
	#Obtener nodos del terreno y de cultivos
	if get_parent() is GridMap:
		soil=get_parent()
		print(soil.get_name())
		if soil.get_child(0) is GridMap:
			crops=soil.get_child(0)
			print(crops.get_name())
	print("Run...")
	
func _calculate_gridPosition(val):
	Globals.gridPosition = Vector3(floor(val.x/4),floor(val.y/4),floor(val.z/4))

func _read_terrain():
	_calculate_gridPosition(Globals.vehiclePosition)
	var num = soil.get_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z)
	return num

func _write_terrain():
	soil.set_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z,soilItem,0)

func _read_crops():
	_calculate_gridPosition(Globals.vehiclePosition)
	var num = crops.get_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z)
	return num

func _write_crops():
	crops.set_cell_item(Globals.gridPosition.x,Globals.gridPosition.y,Globals.gridPosition.z,cropItem,0)

func _update_grass():
	var grassPos = soil.get_used_cells() 
	var cell = null
	#var i
	for i in range(grassPos.size()):
		cell = soil.get_cell_item(grassPos[i].x,grassPos[i].y,grassPos[i].z)
		if cell > 1 and cell<5:
			cell= cell + 1
			soil.set_cell_item(grassPos[i].x,grassPos[i].y,grassPos[i].z,cell,0)

func _update_soil():
	var soilPos = soil.get_used_cells() 
	var cell = null
	#var i
	for i in range(soilPos.size()):
		cell = soil.get_cell_item(soilPos[i].x,soilPos[i].y,soilPos[i].z)
		if cell > 6 and cell<10:
			cell= cell - 1
			soil.set_cell_item(soilPos[i].x,soilPos[i].y,soilPos[i].z,cell,0)
			
func _physics_process(delta):
	
	#Cell system
	var cell
	
	if Input.is_action_pressed("ui_plow"):		
		cell = _read_crops()
		if cell != -1:
			cropItem = -1
			print("Removing crop in:")
			print(Globals.gridPosition)
			print(cell)
			_write_crops()			
		cell = _read_terrain() 
		if cell > 1 and cell < 6:
			soilItem = cell + 4
			if cell != soilItem:
				print("Plowing in:") 
				print(Globals.gridPosition)
				print(soilItem)
				_write_terrain()
	
	if Input.is_action_pressed("ui_fertilize"):
		cell = _read_terrain()
		if cell > 5:
			if cell != soilItem:
				if cell < 9:
					soilItem = cell + 1
					print("Fertilizing in:")
					print(Globals.gridPosition)
					print(soilItem)
					_write_terrain()
				else:
					soilItem = cell
		
	if Input.is_action_pressed("ui_seed"):
		cell = _read_terrain()
		if cell > 5:
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
			if cell > 6:
				soilItem = cell - 1
				_write_terrain()
				
	if Input.is_action_pressed("ui_mow"):
		cell = _read_terrain()
		if cell == 5 or cell == 4:
			soilItem = 2
			print("Mowing in:")
			print(Globals.gridPosition)
			print(cell)
			_write_terrain()
	
	if Input.is_action_just_pressed("ui_info"):
		cell = _read_terrain()
		print ("Info")
		print (Globals.gridPosition)
		print ("soil:")
		print(cell)
		cell = _read_crops()
		print ("Crops:")
		print(cell)
	
	if Input.is_action_just_pressed("ui_accept"):
		_update_grass()
		_update_soil()

func _on_GrassTimer_timeout():
	_update_grass()
	$GrassTimer.start()

func _on_SoilTimer_timeout():
	_update_soil()
	$SoilTimer.start()
