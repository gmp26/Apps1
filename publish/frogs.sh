#!/bin/bash
cd ~/angular/Apps1
grunt mask:frogs
grunt prod
rsync -av ~/angular/Frogs/dist/ gmp26@maths.org:/www/nrich/html/content/00/12/game1/frogs