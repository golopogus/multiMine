extends Node2D

const possibleSizes = [[8,8],[16,16],[16,30]]
var levelSize = possibleSizes[0]

var DANGER = preload("res://danger.tscn")
var SAFE = preload("res://safe.tscn")
var WARNING = preload("res://warning.tscn")
var dangerAreas = 10
var totalMines = dangerAreas + 1
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
var inExit = false
var inSmiley = false
var second = 0
var tens = 0
var hundreds = 0
	
func _unhandled_input(event):
	
#	if Input.is_action_just_pressed("enter"):
#		get_tree().change_scene("res://mineSweeperPlay.tscn")
#	if Input.is_action_just_pressed("esc"):
#		get_tree().quit()
	if Input.is_action_pressed("leftClick"):
		$smileyArea/smiley.play('click')
		if started == true:
			for i in $tiles.get_children():
				if i.mouseIn == true:
					i.unhide()
		else:
			$secondsTimer.start()
			var dist = 100000
			var ans = []
			for i in $startingTiles.get_children():
				if i.mouseIn == true:
					pospos = i.position
					started = true
					addBoard(pospos)
		if inExit == true:
			get_tree().quit()
			
		if inSmiley == true:
			get_tree().change_scene("res://mineSweeperPlay.tscn")
			
	else:
		$smileyArea/smiley.play('idle')
	if Input.is_action_just_pressed("rightClick") and started == true:
		for i in $tiles.get_children():
			if i.mouseIn == true:
				i.addMine()
		
		
func _ready():
#	OS.set_window_size(Vector2(1024,512))
#	$background.scale.x = 2
	subtractCounter()
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

#func _on_nextLevelTimer_timeout():
#	$nextLevelTimer.stop()
#	print('l')
#	get_tree().change_scene("res://level.tscn")

func reconvert(x,y):
	#var newx = (x-8)/16 
	var newx = (x - 24)/cellSize
	var newy = (y - 103)/16 
	return Vector2(newx,newy)
	
func addBoard(area):
	var start = reconvert(area.x,area.y)
	var startingArea = [start, Vector2(start.x + 1,start.y),Vector2(start.x + 1,start.y+1),Vector2(start.x,start.y+1),Vector2(start.x - 1,start.y+1),Vector2(start.x - 1,start.y),Vector2(start.x - 1,start.y - 1),Vector2(start.x,start.y - 1),Vector2(start.x + 1,start.y - 1)]
	$startingTiles.queue_free()
	var startingCol = 0
	var startingRow = 0
	
	var convertStartingArea = []
	for i in startingArea:
		convertStartingArea.append(convertRowAndCol(i.x,i.y))
		#print(convertStartingArea)
	
	
	var startingPos = Vector2(cellSize/2,cellSize/2)
	var row = 0
	var col = 0
	
	
	for i in range(dangerAreas):
		randomize()
		var x = randi() % width
		var y = randi() % length
		var realX = (x*16 + 8) 
		var realY = (y*16 + 8) 

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


func _on_exit_mouse_entered():
	inExit = true


func _on_exit_mouse_exited():
	inExit = false


func _on_smileyArea_mouse_entered():
	inSmiley = true


func _on_smileyArea_mouse_exited():
	inSmiley = false

func _on_secondsTimer_timeout():
	addSecond()
	
func addSecond():
	second += 1
	if second == 1:
		$timer/ones.play('one')
	elif second == 2:
		$timer/ones.play('two')
	elif second == 3:
		$timer/ones.play('three')
	elif second == 4:
		$timer/ones.play('four')
	elif second == 5:
		$timer/ones.play('five')
	elif second == 6:
		$timer/ones.play('six')
	elif second == 7:
		$timer/ones.play('seven')
	elif second == 8:
		$timer/ones.play('eight')
	elif second == 9:
		$timer/ones.play('nine')
	elif second == 10:
		addTens()
		second = 0
		$timer/ones.play('zero')
		
func addTens():
	tens += 1
	if tens == 1:
		$timer/tens.play('one')
	elif tens == 2:
		$timer/tens.play('two')
	elif tens == 3:
		$timer/tens.play('three')
	elif tens == 4:
		$timer/tens.play('four')
	elif tens == 5:
		$timer/tens.play('five')
	elif tens == 6:
		$timer/tens.play('six')
	elif tens == 7:
		$timer/tens.play('seven')
	elif tens == 8:
		$timer/tens.play('eight')
	elif tens == 9:
		$timer/tens.play('nine')
	elif tens == 10:
		addHundreds()
		tens = 0
		$timer/tens.play('zero')
		
func addHundreds():
	hundreds += 1
	if hundreds == 1:
		$timer/hundreds.play('one')
	elif hundreds == 2:
		$timer/hundreds.play('two')
	elif hundreds == 3:
		$timer/hundreds.play('three')
	elif hundreds == 4:
		$timer/hundreds.play('four')
	elif hundreds == 5:
		$timer/hundreds.play('five')
	elif hundreds == 6:
		$timer/hundreds.play('six')
	elif hundreds == 7:
		$timer/hundreds.play('seven')
	elif hundreds == 8:
		$hundreds/hundreds.play('eight')
	elif hundreds == 9:
		$timer/hundreds.play('nine')
	elif hundreds == 10:
		hundreds = 0
		$timer/hundreds.play('zero')

func addCounter():
	totalMines += 1
	mines2Counter()
	
func subtractCounter():
	if totalMines > 0:
		totalMines -= 1
		mines2Counter()
	
func mines2Counter():
	var counter = str(totalMines)
	while len(counter) < 3:
		counter = '0' + counter
	var lengthCounter = len(counter) - 1
	
	
	
	if counter[2] == '1':
		$counter/ones.play('one')
	elif counter[2] == '2':
		$counter/ones.play('two')
	elif counter[2] == '3':
		$counter/ones.play('three')
	elif counter[2] == '4':
		$counter/ones.play('four')
	elif counter[2] == '5':
		$counter/ones.play('five')
	elif counter[2] == '6':
		$counter/ones.play('six')
	elif counter[2] == '7':
		$counter/ones.play('seven')
	elif counter[2] == '8':
		$counter/ones.play('eight')
	elif counter[2] == '9':
		$counter/ones.play('nine')
	elif counter[2] == '0':
		$counter/ones.play('zero')

	if counter[1] == '1':
		$counter/tens.play('one')
	elif counter[1] == '2':
		$counter/tens.play('two')
	elif counter[1] == '3':
		$counter/tens.play('three')
	elif counter[1] == '4':
		$counter/tens.play('four')
	elif counter[1] == '5':
		$counter/tens.play('five')
	elif counter[1] == '6':
		$counter/tens.play('six')
	elif counter[1] == '7':
		$counter/tens.play('seven')
	elif counter[1] == '8':
		$counter/tens.play('eight')
	elif counter[1] == '9':
		$counter/tens.play('nine')
	elif counter[1] == '0':
		$counter/tens.play('zero')

	if counter[0] == '1':
		$counter/hundreds.play('one')
	elif counter[0] == '2':
		$counter/hundreds.play('two')
	elif counter[0] == '3':
		$counter/hundreds.play('three')
	elif counter[0] == '4':
		$counter/hundreds.play('four')
	elif counter[0] == '5':
		$counter/hundreds.play('five')
	elif counter[0] == '6':
		$counter/hundreds.play('six')
	elif counter[0] == '7':
		$counter/hundreds.play('seven')
	elif counter[0] == '8':
		$counter/hundreds.play('eight')
	elif counter[0] == '9':
		$counter/hundreds.play('nine')
	elif counter[0] == '0':
		$counter/hundreds.play('zero')
			
	
			


