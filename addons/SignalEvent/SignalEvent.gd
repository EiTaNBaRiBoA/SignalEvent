class_name SignalEvent

static var cache_array: Array[CachingSignals] = []

#region Signal Utils
## Connect a signal method to a signal, defaultArgs are optional for passing args everytime you call emit this signal \n debugEmit is for easier debugging when tracing who emitted the signal
static func safe_connect_signal(signalRef: Signal, callable: Callable, defaultArgs: Variant=[], debugEmit: bool=false, connectFlags: int=0) -> void:
		if not _isConnected(signalRef, callable):
			if defaultArgs.size() > 0:
				if defaultArgs.size() > callable.get_argument_count():
					printerr("More Argument passed than the method can contain")
					return
				var default_args_callable: Callable = func(dynamicArgs: Variant=null): _create_func(defaultArgs, dynamicArgs, callable, signalRef, debugEmit)
				cache_array.append(CachingSignals.new(default_args_callable, signalRef, str(callable)))
				signalRef.connect(default_args_callable, connectFlags)
			else:
				cache_array.append(CachingSignals.new(callable, signalRef, str(callable)))
				signalRef.connect(callable, connectFlags)

## Disconnecting a callable from a specific signal
static func safe_disconnect_callable(signalRef: Signal, callable: Callable) -> void:
	for cache: CachingSignals in cache_array.duplicate(true): # Duplicating to avoid modification during foreach
		if cache.callable_origibal_name == str(callable)&& \
			cache.signalRef == signalRef:
				signalRef.disconnect(cache.callable)
				cache_array.erase(cache)

## Disconnecting all callables from a specific signal
static func safe_disconnect_all_callables(signalRef: Signal) -> void:
		for cache: CachingSignals in cache_array.duplicate(true): # Duplicating to avoid modification during foreach
			if signalRef == cache.signalRef:
				signalRef.disconnect(cache.callable)
				cache_array.erase(cache)

## Disconnecting all signals from a specific callable
static func safe_disconnect_all_signals(callable: Callable) -> void:
	for cache: CachingSignals in cache_array.duplicate(true): # Duplicating to avoid modification during foreach
		if str(callable) == cache.callable_origibal_name: # looking at what this callable connected
			cache.signalRef.disconnect(cache.callable)
			cache_array.erase(cache)
#endregion

#region private methods

static func _isConnected(signalRef: Signal, callable: Callable) -> bool:
	for cache: CachingSignals in cache_array.duplicate(true): # Duplicating to avoid modification during foreach
		if cache.callable_origibal_name == str(callable)&& \
			cache.signalRef == signalRef:
				printerr("The signal %s is already connected %s" % [signalRef.get_name(), _getCorrectCallStack(signalRef.get_object().get_script().get_path().get_file())])
				return true
	return false

static func _create_func(defaultArgs: Array, dynamicArgs: Variant, callable: Callable, signalRef: Signal, debugEmit: bool=false) -> void:
	var all_args = _extractArgs(defaultArgs)
	all_args += _extractArgs(dynamicArgs)
	var scriptName: String =""
	if signalRef.get_object().get_script() == null:
		scriptName = signalRef.get_object().get_class()
	else:
		scriptName = signalRef.get_object().get_script().get_path().get_file() # # get_script() returns node , get_path() returns NodePath,  get_file() returns script name
	if  not _validateAmountArgs(callable,all_args):
		printerr("too little or too many arguments passed from signal '%s' from %s %s" % [signalRef.get_name(), scriptName, _getCorrectCallStack(scriptName)])
		return
	if not _validateArgs(callable, all_args):
		printerr("Arguments passed to the signal '%s' are not valid" % signalRef.get_name())
		return
	if debugEmit: print("Signal '%s' %s" % [signalRef.get_name(), _getCorrectCallStack(scriptName)])
	callable.callv(all_args) # to extract params and call method

static func _extractArgs(args: Variant) -> Array:
	if typeof(args) == TYPE_ARRAY:
		return args
	elif args == null:
		return []
	else:
		return [args]

static func _validateAmountArgs(callable: Callable, all_args: Array) -> bool:
	var defaultArgs :int = 0 
	for method: Dictionary in callable.get_object().get_method_list():
		if method.name == callable.get_method():
			defaultArgs = method.default_args.size()
			break;
	
	if all_args.size() == callable.get_argument_count():
		return true
	else:
		return all_args.size() == callable.get_argument_count() - defaultArgs

static func _validateArgs(callable: Callable, all_args: Array) -> bool:
	for method: Dictionary in callable.get_object().get_method_list():
		if method.name == callable.get_method():
			for j in all_args.size():
				var verificationType: bool = false # Defaults to false, so if nothing is valid it will return false
				for i in method.args.size():
					if typeof(all_args[j]) == method.args[i].type&&i == j: # # Comparing if they are the same index
						verificationType = true
				if not verificationType: return false # if all didn't match
	return true

static func _getCorrectCallStack(scriptName: String) -> String:
	for i in get_stack().size():
		if get_stack()[i].source.get_file() == scriptName:
			return "from function: %s() in line %s" % [get_stack()[i].function, get_stack()[i].line]
	return ""

# inner class to hold in the cacheArray to help deleting callables
class CachingSignals:
	var callable: Callable
	var signalRef: Signal
	var callable_origibal_name: String = "" # Caching original name to be able to delete anonymouse callables
	func _init(set_callable: Callable, set_signal: Signal, set_callable_name: String) -> void:
		callable = set_callable
		signalRef = set_signal
		callable_origibal_name = set_callable_name
		
#endregion
