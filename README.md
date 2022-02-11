# CBT Script (Chase's Batch Tagger)

A script for tagging files and folders.

Can be used in a command line with `TAG <file/folder name> <tag>`, but this was meant to be used from the context menu

## Context Menu

Number of tags is limited to 135 (9 sublists of 15 tags).

After running `install_context_menu.cmd`, moving these files or this folder will break it. Make sure to uninstall before doing so and reinstall afterwards.

### Installing

1. Put your tags into `tags.txt`
2. Run `install_context_menu.cmd`

### Updating Tags

1. Run `uninstall_context_menu.cmd`
2. Update `tags.txt`
3. Run `install_context_menu.cmd`

### Uninstalling

Run `uninstall_context_menu.cmd`