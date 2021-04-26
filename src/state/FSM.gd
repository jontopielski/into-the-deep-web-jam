class_name FSM
extends Node

var debug = false
var states = {}
var state_curr = null
var state_next = null
var state_last = null
var obj = null

func _init(_obj, states_parent_node, initial_state, _debug = false):
	self.obj = _obj
	self.debug = _debug
	_set_states_parent_node(states_parent_node)
	state_next = initial_state

func _set_states_parent_node(pnode):
	if debug: print("_found ", pnode.get_child_count(), " states")
	if pnode.get_child_count() == 0:
		return
	var state_nodes = pnode.get_children()
	for state_node in state_nodes:
		if debug: print("_adding state: ", state_node.name)
		states[ state_node.name ] = state_node
		state_node.fsm = self
		state_node.obj = self.obj

func run_machine(delta):
	if state_next != state_curr:
		if state_curr != null:
			if debug:
				print("_", obj.name, ": changing from state ", state_curr.name, " to ", state_next.name)
			state_curr.on_exit()
		elif debug:
			print("_", obj.name, ": starting with state ", state_next.name)
		state_last = state_curr
		state_curr = state_next
		state_curr.on_enter()
	# run state
	state_curr.run(delta)

func set_state_forced(state_name):
	if state_curr != null:
		if debug:
			print("_", obj.name, ": changing from state ", state_curr.name, " to ", state_name.name)
		state_curr.on_exit()
		state_last = state_curr
		state_curr = state_name
		state_curr.on_enter()
