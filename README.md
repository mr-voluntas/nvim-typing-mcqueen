# nvim-typing-mcqueen

MonkeyType style nvim plugin

Notes:

- No setup function needed as this plugin will have great defaults.
- We should mark "private packages" with an \_underscore.
- The more we splitup the plugin the slower it becomes.
- Plugin is cached after first require.
- We can do plugin config via vim.g.nvim-typing-mcqueen global table.
- Its faster to only require modules when needed.

Todo:

- Open a floating window -- DONE
- Add the text that needs to be typed out - DONE
- Track keystrokes
- Make text red or green

NOTE:

- I think we should loop through all characters of the buffer.
- for each character we can check for certain things.
- move forward and back in the buffer based on key presses (space = forward, backspace = back)
- check if the key presses match the current character, if so.. hightlight it.
- if we go back, unhighlight the current character.


recursive function:
- keep going until the end of the array of words to type.
- We can go forward and back.
- can compare.
