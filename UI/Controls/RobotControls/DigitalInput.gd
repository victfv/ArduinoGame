extends HBoxContainer

func getIn(val):
	if val == 0:
		return 0
	else:
		return 1

func setName(newName):
	$Name.text = newName
