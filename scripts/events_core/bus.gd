extends Node

var subscribers = {}


func subscribe(event, function: Callable) -> void:
	var event_type = typeof(event)
	if subscribers.get(event_type, null) == null:
		subscribers[event_type] = []
		
	subscribers[event_type].append(function)


func create_event(event: IEvent) -> void:
	var event_type = typeof(event)

	
	var event_subscribers = subscribers.get(event_type, [])
	for index in range(len(event_subscribers)):
		if event_subscribers[index] == null:
			subscribers[event].remove_at(index)
			
		event_subscribers[index].call_deferred(event)
