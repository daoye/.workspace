# Console Plugin

A Neovim plugin that intercepts all output (info, error, warnings, etc.) and consolidates them into a unified console buffer instead of allowing plugin errors to suddenly pop up and interrupt your workflow.

## Features

- Intercepts all Neovim output including errors, warnings, and notifications
- Consolidates output into a single console buffer for easy review
- Preserves console entries between Neovim sessions (persistent storage)
- Provides commands to view and manage console
- Integrates with status line to show error/warning counts
- Toggle console window with a single command

## Commands

- `:Console` - Toggles the console window to view all collected entries
- `:ClearConsole` - Clears the current console buffer and log file

## Usage

Once installed, the plugin automatically starts intercepting output. You can access your console at any time using the `:Console` command. The console window can be toggled open/closed with the same command.

## Status Line Integration

The plugin provides a function to display error and warning counts in your status line:

```lua
function()
  return _G.ConsoleBuffer and _G.ConsoleBuffer.get_status_summary() or ''
end
```

## Persistence

All console entries are saved to a log file in your Neovim data directory (`stdpath("data")`) and automatically loaded when you start Neovim.

## License

MIT