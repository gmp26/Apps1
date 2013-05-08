#!/bin/bash
cd ~/angular/Apps1
grunt mask:mathmo
grunt prod
rsync -av ~/angular/Apps1/dist/ gmp26@maths.org:/www/nrich/html/mathmo