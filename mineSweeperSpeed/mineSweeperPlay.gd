extends Node2D

const possibleSizes = [[8,8],[16,16],[16,30]]
var levelSize = possibleSizes[0]

var DANGER = preload("res://danger.tscn")
var SAFE = preload("res://safe.tscn")
var WARNING = preload("res://warning.tscn")
var dangerAreas = 10
var cellSize = 16
var dangerPos = []
var warningPos = []
var length = levelSize[1]
var width = levelSize[0]
var size = length * width
var newPos = Vector2()
var noGo = []
var convertedHolePos = Vector2()
var finished = false
var badAreas = []
var turnCounter = 0
var started = false
var pospos = Vector2()

	
func _unhandled_input(event):
	
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene("res://mineSweeperPlay.tscn")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_pressed("leftClick"):
		if started == true:
			for i in $tiles.get_children():
				if i.mouseIn == true:
					i.unhide()
		else:
			
			var dist = 100000
			var ans = []
			for i in $startingTiles.get_children():
				if i.mouseIn == true:
					pospos = i.position
					started = true
					addBoard(pospos)
		
	if Input.is_action_just_pressed("rightClick") and started == true:
		for i in $tiles.get_children():
			if i.mouseIn == true:
				i.addMine()
		
func _ready():
	
	var startingPos = Vector2(cellSize/2,cellSize/2)
	var row = 0
	var col = 0
	
	for i in range(size):
		addSafe1(startingPos)
			
		
		if startingPos.x < ((width*cellSize) - cellSize/2):
			startingPos.x += cellSize
			col += 1
		else:
			col = 0
			row += 1
			startingPos.x = cellSize/2
			startingPos.y = cellSize/2 + (cellSize*row)
			
		
func addSafe1(pos):
	var safe = SAFE.instance()
	$startingTiles.add_child(safe)
	safe.position = pos	+ Vector2(16,95)

func addSafe(pos,posCheck):
	
	var safe = SAFE.instance()
	$tiles.add_child(safe)
	safe.position = pos	+ Vector2(16,95)
	
func addWarning(pos,posCheck):
	
	var warning = WARNING.instance()
	$tiles.add_child(warning)
	warning.position = pos + Vector2(16,95)
		
func addDanger(pos,posCheck):
	
	var danger = DANGER.instance()
	$tiles.add_child(danger)
	danger.position = pos + Vector2(16,95)

	
func convertRowAndCol(numx,numy):
	newPos.x = numx*cellSize + cellSize/2
	newPos.y = numy*cellSize + cellSize/2
	return newPos

func _on_nextLevelTimer_timeout():
	$nextLevelTimer.stop()
	print('l')
	get_tree().change_scene("res://level.tscn")

func reconvert(x,y):
	var newx = (x-8)/16
	var newy = (y-8)/16
	return Vector2(newx,newy)
	
func addBoard(area):
	print(area)
	var start = reconvert(area.x,area.y)
	var startingArea = [start, Vector2(start.x + 1,start.y),Vector2(start.x + 1,start.y+1),Vector2(start.x,start.y+1),Vector2(start.x - 1,start.y+1),Vector2(start.x - 1,start.y),Vector2(start.x - 1,start.y - 1),Vector2(start.x,start.y - 1),Vector2(start.x + 1,start.y - 1)]
	print(area)
	$startingTiles.queue_free()
	var startingCol = 0
	var startingRow = 0
	
	var convertStartingArea = []
	for i in startingArea:
		convertStartingArea.append(convertRowAndCol(i.x,i.y))
		print(convertStartingArea)

	
	var startingPos = Vector2(cellSize/2,cellSize/2)
	var row = 0
	var col = 0
	
	
	for i in range(dangerAreas):
		randomize()
		var x = randi() % width
		var y = randi() % length
		var realX = (x*32 + 16) + 16
		var realY = (y*32 + 16) + 95

		while Vector2(x,y) in startingArea or Vector2(x,y) in dangerPos:
			x = randi() % width
			y = randi() % length
			
			
		dangerPos.append(Vector2(x,y))

	for i in dangerPos:
		warningPos.append(Vector2(i.x + 1,i.y+1))
		warningPos.append(Vector2(i.x+1,i.y-1))
		warningPos.append(Vector2(i.x-1,i.y+1))
		warningPos.append(Vector2(i.x-1,i.y-1))
		warningPos.append(Vector2(i.x+1,i.y))
		warningPos.append(Vector2(i.x-1,i.y))
		warningPos.append(Vector2(i.x,i.y+1))
		warningPos.append(Vector2(i.x,i.y-1))

			
	
	#$tiles.position = Vector2(16,95)

	for i in range(size):
		if Vector2(col,row) in dangerPos:
			addDanger(startingPos,convertStartingArea)

		elif Vector2(col,row) in warningPos:
			addWarning(startingPos,convertStartingArea)

		else:
			addSafe(startingPos,convertStartingArea)


		if startingPos.x < ((width*cellSize) - cellSize/2):
			startingPos.x += cellSize
			col += 1
		else:
			col = 0
			row += 1
			startingPos.x = cellSize/2
			startingPos.y = cellSize/2 + (cellSize*row)

	for child in $tiles.get_children():
		if "warning" in child.name:
			child.countNeighbors()


	clearUnknown(pospos)
	
func clearUnknown(pos):

	for i in $tiles.get_children():
		if i.position == pos:
			print(i.name)
			if "safe" in i.name:
				if i.get_node("hidden").visible == true:
					i.get_node("hidden").hide()
				if i.position in noGo:
					pass
				else:
					noGo.append(i.position)
					clearUnknown(i.position + Vector2(cellSize,0))
					clearUnknown(i.position + Vector2(-cellSize,0))
					clearUnknown(i.position + Vector2(0,cellSize))
					clearUnknown(i.position + Vector2(0,-cellSize))
					clearUnknown(i.position + Vector2(cellSize,cellSize))
					clearUnknown(i.position + Vector2(-cellSize,-cellSize))
					clearUnknown(i.position + Vector2(-cellSize,cellSize))
					clearUnknown(i.position + Vector2(cellSize,-cellSize))
			elif "warning" in i.name:
				if i.get_node("hidden").visible == true:
					i.get_node("hidden").hide()
#				if i.get_node("hitOnce").visible == true:
#					i.get_node("hitOnce").hide()
				#i.showText()

	
	
	
#
#
#
