#!/bin/bash

Xvfb :1 -screen 0 1024x768x24 > /dev/null 2>&1 &
DISPLAY=:1 ~/eclipse/eclimd -b > /dev/null 2>&1
