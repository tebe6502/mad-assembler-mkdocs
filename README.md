# Mad-Assembler (MADS)

The documentation for [**Mad-Assembler (MADS)**](https://github.com/tebe6502/Mad-Assembler) is created using [MkDocs](https://www.mkdocs.org/). This repository contains the Polish original by Tomasz Biela (tebe) and its English translation by Peter Dell (JAC!) in separate folders.

## Building
If you have **MkDocs** installed, you can run the 'Makefile.bat' script in the respective folder to display the documentation using MkDoc's built-in local webserver.
```
mkdocs serve --help
```
To create an HTML version of the documentation in a folder, you can use the following command.
```
mkdocs build --help
```
## Formatting, Wording and Spelling Rules
Formatting, wording and spelling rules are essential for a consistent document and good reading experience.
- Command line options and their arguments are lower case as in the output on the commannt line, see [Usage](#/docs/en/docs/usage.md).
- Messages are bold and in single quotes **'Example message'**.
- Use **WDC 65816** for references to the Western Design Center 65816 CPU. 
- Use 'added directive' instead of 'added new directive', because adding implies that it is new already
- Use upper case for directives and commands, use lower case for labels and operands
