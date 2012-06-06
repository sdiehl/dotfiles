#!/bin/bash

# Toggle keyboard only mode.

# Hide the cursor
unclutter -idle 0 -root & disown

# Disable the hardware
synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
