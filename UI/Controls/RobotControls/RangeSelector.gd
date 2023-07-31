extends HBoxContainer

func setName(newName):
	$Name.text = newName

var rngMin = -1.0
var rngMax = 1.0

func setRange(rangeMin, rangeMax):
	rngMin = rangeMin
	rngMax = rangeMax
	$ToRange.text = " to: " + str(rangeMin) + " up to " + str(rangeMax)

func getInRange(val) -> float:
	return range_lerp(val, int($MinLine.text), int($MaxLine.text), rngMin, rngMax)
	print("MIN: " + str(int($MinLine.text)))

func _ready():
	pass
