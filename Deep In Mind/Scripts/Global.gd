extends Node

const VERSION = "1.1"

var collected_memories = []
var banned_memories = []

func add_memory(memory):
	if memory == "" || memory == null:
		return ERR_INVALID_PARAMETER
	
	if !collected_memories.has(memory):
		collected_memories.push_back(memory)
		print("Remembered: " + str(memory))
		
		return OK
	else:
		printerr("Memory already added")
		return ERR_ALREADY_EXISTS

func remove_memory(memory):
	if memory == "" || memory == null:
		return ERR_INVALID_PARAMETER
	
	if collected_memories.has(memory):
		collected_memories.erase(memory)
		print("Forgot: " + str(memory))
		
		return OK
	else:
		printerr("Memory doesn't exist'")
		return ERR_DOES_NOT_EXIST

func ban_memory(memory):
	if memory == "" || memory == null:
		return ERR_INVALID_PARAMETER
	
	if !banned_memories.has(memory):
		banned_memories.push_back(memory)
		print("Banned: " + str(memory))
		
		return OK
	else:
		printerr("Memory already banned")
		return ERR_ALREADY_EXISTS

func unban_memory(memory):
	if memory == "" || memory == null:
		return ERR_INVALID_PARAMETER
	
	if banned_memories.has(memory):
		banned_memories.erase(memory)
		print("Unbanned: " + str(memory))
		
		return OK
	else:
		printerr("Memory not banned")
		return ERR_DOES_NOT_EXIST

func has_memory(memory):
	return collected_memories.has(memory)

func has_ban(memory):
	return banned_memories.has(memory)
