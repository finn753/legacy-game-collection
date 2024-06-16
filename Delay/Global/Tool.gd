extends Node

func sum_dic(dic):
	var sum = 0.0
	
	for k in dic.keys():
		sum += float(dic[k])
	
	return sum
