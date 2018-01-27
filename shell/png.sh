#!/bin/bash

echo "-------PNGQuant begin-------"
pngquant.exe 256 --force --ext .png C:\\Dev\\workspace\\IdeaProject\\$1\\**\\*.png
echo "--------PNGQuant End--------"