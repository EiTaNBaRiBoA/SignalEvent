## SignalEvent - Enhanced Signal Handling for Godot

SignalEvent is a Godot plugin that simplifies and enhances signal connections in your Godot projects. It provides type-safe and debug-friendly signal management with default arguments and easy disconnection capabilities.

### Features

- **Safe Connections with Default Arguments:** Define default arguments for your signal connections, streamlining signal emissions and reducing boilerplate code.
- **Simplified Disconnection:** Disconnect signal connections by callable or disconnect all callables from a specific signal with ease.
- **Debug-Friendly Signal Emission:** Optionally enable debug messages that trace signal emissions, pinpointing their origin in your code for efficient debugging.
- **Argument Validation:** Ensure type safety by validating signal arguments against the connected method's signature, preventing runtime errors caused by mismatched types.

### Installation

1. Download the `SignalEvent.gd` file from this repository.
2. Place the file in your Godot project's `addons/` directory.

### Usage

```gdscript
extends Control

signal argument_signal
signal funcs_signal
signal no_param_signal

func _ready():
	# Connecting with default argument and debug emission
	SignalEvent.safe_connect_signal(argument_signal, func_arguments, [1], true) 
	argument_signal.emit([2, "Hello"])  # Outputs: 2, "Hello"

	# Disconnecting a callable from a specific signal
	SignalEvent.safe_disconnect_callable(argument_signal, func_arguments)

	# Connecting with multiple default funcs
	SignalEvent.safe_connect_signal(funcs_signal, func_arguments, [1, 2,"Hello"])
	SignalEvent.safe_connect_signal(funcs_signal, func_optional)
	funcs_signal.emit() # Outputs: 1,2,"Hello" and 1 

	# Disconnecting all callables from a signal
	SignalEvent.safe_disconnect_all_callables(funcs_signal)
	
	# Simple connection to a func with an optional parameter
	SignalEvent.safe_connect_signal(no_param_signal, func_optional)
	no_param_signal.emit(5) # Outputs: 5

	# Disconnecting all signals that are connected to a specific func
	SignalEvent.safe_disconnect_all_signals(func_optional)
	
	# This emission won't reach func_optional because it's disconnected
	no_param_signal.emit(5) 
	
	# Symmetrically connect signals and callables 
	var signals_to_connect : Array[Signal] = [argument_signal, funcs_signal]
	var callables_to_connect : Array[Callable] = [func_arguments, func_optional]
	SignalEvent.safe_connect_symmetrically(signals_to_connect, callables_to_connect)

	# Emit the signals (now connected symmetrically)
	argument_signal.emit([10, 20, "Symmetric"]) 
	funcs_signal.emit()

	# Symmetrically disconnect signals and callables
	SignalEvent.safe_disconnect_symmetrically(signals_to_connect, callables_to_connect)
	



func func_arguments(a : int, b : int, c : String) -> void:
	print(a)
	print(b)
	print(c)

func func_optional(a : int = 1) -> void:
	print(a)
```

### API Reference

#### `safe_connect_signal(signalRef : Signal, callable : Callable, defaultArgs : Variant = [], debugEmit : bool = false, connectFlags : int = 0) -> void`

Connects a signal to a callable with optional default arguments and debug messages.

- **`signalRef`:** The signal to connect to.
- **`callable`:** The callable method to connect.
- **`defaultArgs`:** (Optional) An array of default arguments to pass to the callable.
- **`debugEmit`:** (Optional) Enables debug messages on signal emission.
- **`connectFlags`:** (Optional) Connection flags (see Godot documentation).

#### `safe_disconnect_callable(signalRef : Signal, callable : Callable) -> void`

Disconnects a specific callable from a signal.

- **`signalRef`:** The signal to disconnect from.
- **`callable`:** The callable to disconnect.

#### `safe_disconnect_all_callables(signalRef : Signal) -> void`

Disconnects all callables from a signal.

- **`signalRef`:** The signal to disconnect from.

#### `safe_disconnect_all_signals(callable : Callable) -> void`

Disconnects a callable from all connected signals.

- **`callable`:** The callable to disconnect.

#### `safe_connect_symmetrically(signalsRef : Array[Signal], callables : Array[Callable], defaultArgs : Variant = [], debugEmit: bool=false, connectFlags: int=0) -> void`

Connects an array of signals to an array of callables.

- **`signalsRef`:** An array of signals to connect.
- **`callables`:** An array of callables to connect.
- **`defaultArgs`:** (Optional) An array of default arguments to pass to the callables.
- **`debugEmit`:** (Optional) Enables debug messages on signal emission.
- **`connectFlags`:** (Optional) Connection flags (see Godot documentation).


#### `safe_disconnect_symmetrically(signalsRef : Array[Signal], callables : Array[Callable]) -> void`

Disconnects an array of callables from an array of signals.

- **`signalsRef`:** An array of signals to disconnect from.
- **`callables`:** An array of callables to disconnect.


### Contributing

Contributions are welcome! Feel free to open issues or pull requests.

### License

This plugin is released under the MIT License. 
