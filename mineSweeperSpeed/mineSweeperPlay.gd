extends Node2D

const possibleSizes = [[8,8],[16,16],[16,30]]
var levelSize = possibleSizes[0]

var DANGER = preload("res://danger.tscn")
var SAFE = preload("res://safe.tscn")
var WARNING = preload("res://warning.tscn")
#var PLAYER = preload("res://player.tscn")
#var UNKNOWN = preload("res://unknown.tscn")
var dangerAreas = 10
var cellSize = 32
var dangerPos = []
var warningPos = []
var length = levelSize[1]
var width = levelSize[0]
var size = length * width
var newPos = Vector2()
var noGo = []
var holePos = Vector2(-1,-1)
var convertedHolePos = Vector2()
var finished = false
var badAreas = []
var turnCounter = 0
#func _process(delta):
#
#	if $player.position == convertedHolePos and finished == false:
#		finished = true
#		$nextLevelTimer.start()
#		$player.noMove()
	
func _unhandled_input(event):
	
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene("res://mineSweeperPlay.tscn")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_just_pressed("leftClick"):
		for i in $tiles.get_children():
			if i.mouseIn == true:
				i.unhide()
	if Input.is_action_just_pressed("rightClick"):
		for i in $tiles.get_children():
			if i.mouseIn == true:
				i.addMine()
		
func _ready():
	
	var startingCol = 0
	var startingRow = 0
	
	while startingCol == 0 or startingCol == width - 1:
		randomize()
		startingCol = randi() % width
		while startingRow == 0 or startingRow == length - 1:
			randomize()
			startingRow = randi() % length

	var startingArea = [Vector2(startingCol,startingRow + 1),Vector2(startingCol,startingRow),Vector2(startingCol - 1,startingRow),Vector2(startingCol - 1,startingRow + 1),Vector2(startingCol,startingRow - 1),Vector2(startingCol + 1,startingRow + 1),Vector2(startingCol + 1,startingRow),Vector2(startingCol + 1,startingRow - 1),Vector2(startingCol - 1,startingRow - 1)]
	var convertStartingArea = []
	
	for i in startingArea:
		convertStartingArea.append(convertRowAndCol(i.x,i.y))
	
	var startingPos = Vector2(cellSize/2,cellSize/2)
	var row = 0
	var col = 0
	
	
	for i in range(dangerAreas):
		randomize()
		var x = randi() % width
		var y = randi() % length
		while Vector2(x,y) in startingArea or Vector2(x,y) in warningPos or Vector2(x,y) in dangerPos:
			x = randi() % width
			y = randi() % length
			
		dangerPos.append(Vector2(x,y))
		warningPos.append(Vector2(x+1,y+1))
		warningPos.append(Vector2(x+1,y-1))
		warningPos.append(Vector2(x-1,y+1))
		warningPos.append(Vector2(x-1,y-1))
		warningPos.append(Vector2(x+1,y))
		warningPos.append(Vector2(x-1,y))
		warningPos.append(Vector2(x,y+1))
		warningPos.append(Vector2(x,y-1))
	
	var badCount = 0
	for i in dangerPos:
		if badCount < dangerAreas/2:
			badAreas.append(i)
			badCount += 1
			
	
#	while holePos.x < 0 or holePos.x > 7 or holePos.y > 7 or holePos.y < 0:
#		randomize()
#		holePos = warningPos[randi() % len(warningPos)]
#	print(holePos)
#	convertedHolePos = convertRowAndCol(holePos.x,holePos.y)
#
	
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
			
#	var player = PLAYER.instance()
#	add_child(player)
#	player.position = convertStartingArea[0]
	
	for child in $tiles.get_children():
		if "warning" in child.name:
			child.countNeighbors()
			
	clearUnknown(convertStartingArea[1])
	
#	var badAreas2 = []
#	for i in badAreas:
#		badAreas2.append(convertRowAndCol(i.x,i.y))
#	for i in $tiles.get_children():
#		if i.position in badAreas2:
#			i.bad = true
		

func addSafe(pos,posCheck):
	
	var safe = SAFE.instance()
	$tiles.add_child(safe)
	safe.position = pos	
	if pos in posCheck:
		safe.get_node("hidden").hide()
	
func addWarning(pos,posCheck):
	
	var warning = WARNING.instance()
	$tiles.add_child(warning)
	warning.position = pos
	if pos in posCheck:
		warning.get_node("hidden").hide()
		
func addDanger(pos,posCheck):
	
	var danger = DANGER.instance()
	$tiles.add_child(danger)
	danger.position = pos
	if pos in posCheck:
		danger.get_node("hidden").hide()
	
func convertRowAndCol(numx,numy):
	newPos.x = numx*cellSize + cellSize/2
	newPos.y = numy*cellSize + cellSize/2
	return newPos

func clearUnknown(pos):
	
	for i in $tiles.get_children():
		if i.position == convertRowAndCol(holePos.x,holePos.y):
			i.becomeHole()
		if i.position == pos:
			if "safe" in i.name:
				if i.get_node("hidden").visible == true:
					i.get_node("hidden").hide()
#				if i.get_node("hitOnce").visible == true:
#					i.get_node("hitOnce").hide()
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
			if "warning" in i.name:
				if i.get_node("hidden").visible == true:
					i.get_node("hidden").hide()
#				if i.get_node("hitOnce").visible == true:
#					i.get_node("hitOnce").hide()
				i.showText()
	

#func addUnknown(pos):
	#var unknown = UNKNOWN.instance()
	#$test.add_child(unknown)
	#unknown.position = pos


func _on_nextLevelTimer_timeout():
	$nextLevelTimer.stop()
	print('l')
	get_tree().change_scene("res://level.tscn")
