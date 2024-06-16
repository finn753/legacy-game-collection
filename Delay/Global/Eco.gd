extends Node

const CERTIFICATE_VERSION = 1
onready var os = OS.get_name()

const SELF = "Last Moment"
const GAMES = ["My Garden","Last Moment","Donut Seduction","Ghosthunter Mansion"]

var self_path = ""

var installed_games = []

func _ready():
	create_certificate()
	validate_installed_games()

func create_certificate():
	var path = "user://"
	
	var certificate = {
		"Version": CERTIFICATE_VERSION,
		"Game": SELF,
		"OS": os,
		"Path": "no"
	}
	
	var file = File.new()
	file.open(path + SELF + ".validate", File.WRITE)
	
	var cself_path = file.get_path_absolute()
	certificate["Path"] = str(cself_path)
	
	file.store_var(certificate)
	file.close()
	
	cself_path = cself_path.replace("/" + SELF + "/" + SELF + ".validate","")
	self_path = cself_path

func validate_installed_games():
	print("Validate:")
	
	installed_games = []
	
	var dir = Directory.new()
	
	for g in GAMES:
		if g == SELF:
			continue
		
		var file_path = self_path + "/" + g + "/" + g + ".validate"
		
		if dir.file_exists(file_path):
			var data
			
			var file = File.new()
			var err = file.open(file_path, File.READ)
			if err == OK:
				data = file.get_var()
			file.close()
			
			if data != null:
				if data["Version"] == CERTIFICATE_VERSION && data["Game"] == g && data["OS"] == os:
					installed_games.append(g)
	
	print(installed_games)
