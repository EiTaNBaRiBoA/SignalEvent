## SignalEvent - Enhanced Signal Handling for Godot

SignalEvent is a Godot plugin designed to streamline and secure your signal connections, making your code more robust and easier to debug.

### Features

- **Safe Connection with Default Arguments:** Connect signals with optional default arguments that are passed automatically on emission.
- **Simplified Disconnection:** Disconnect signals by callable or disconnect all callables from a specific signal with ease.
- **Debug-Friendly Emission:** Optionally enable debug messages to trace signal emissions, pinpointing their origin for efficient troubleshooting.
- **Argument Validation:** Ensures type safety by validating signal arguments against the connected method's signature, preventing runtime errors.

### Installation

1. Download the `SignalEvent.gd` file from this repository.
2. Place the file in your Godot project's `addons/` directory.
3. Activate the plugin in the Project Settings > Plugins tab.

### Usage

```gdscript
extends Control

signal testDictionary
signal testVars
signal testSignalParam

func _ready():
	# Connecting with default argument and debug emission
	SignalEvent.safe_connect_signal(testDictionary, TestFunc, [1], true) 
	testDictionary.emit([2, "Hello"])

	# Disconnecting a specific callable
	SignalEvent.safe_disconnect_callable(testDictionary, TestFunc)

	# Disconnecting all callables from a signal
	SignalEvent.safe_disconnect_all_callables(testDictionary)

	# Connecting with multiple default arguments
	SignalEvent.safe_connect_signal(testVars, TestFunc, [1, 2])
	testVars.emit("Hello")

	# Simple connection
	SignalEvent.safe_connect_signal(testSignalParam, TestFunc2)
	testSignalParam.emit(1)

func TestFunc(aArgument : int, b : int, c : String) -> void:
	print(aArgument)
	print(b)
	print(c)

func TestFunc2(a : int) -> void:
	print(a)
```

### API

#### `safe_connect_signal(signalRef : Signal, callable : Callable, defaultArgs : Variant = [], debugEmit : bool = false, connectFlags : int = 0) -> void`

Connects a signal to a callable.

- `signalRef`: The signal to connect to.
- `callable`: The callable method to connect.
- `defaultArgs`: An optional array of default arguments.
- `debugEmit`: Enables debug messages on signal emission.
- `connectFlags`: Optional connection flags (see Godot documentation).

#### `safe_disconnect_callable(signalRef : Signal, callable : Callable) -> void`

Disconnects a specific callable from a signal.

- `signalRef`: The signal to disconnect from.
- `callable`: The callable to disconnect.

#### `safe_disconnect_all_callables(signalRef : Signal) -> void`

Disconnects all callables from a signal.

- `signalRef`: The signal to disconnect from.

#### `safe_disconnect_all_signals(callable : Callable) -> void`

Disconnects a callable from all connected signals.

- `callable`: The callable to disconnect.


### Contributing

Contributions are welcome! Feel free to open issues or pull requests.

### License

This plugin is released under the MIT License.
