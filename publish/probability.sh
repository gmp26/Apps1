#!/bin/bash
cd ~/angular/Apps1
grunt mask:probability
grunt prod
rsync -av ~/angular/Apps1/dist/ gmp26@maths.org:/www/nrich/html/probabilityApps