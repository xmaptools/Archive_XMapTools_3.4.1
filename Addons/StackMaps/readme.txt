Stackmaps was created by Julien Reynes and added as extension of XMapTools by Pierre Lanari. This program is distributed via an open source MIT license (see below).

Link: http://ftir.julienreynes.fr/stackmaps

Stackmaps allows you to Stack maps using user selected reference points (>=3) and is based on a affine transformation algorithm (scaling, shearing & rotation components).

StackMaps can be downloaded directly via the XMapTools interface using the Extension manager:
	1. Open MATLAB©, set the working directory and open XMapTools
	2. In menu, select File > Add-Ons > Manage Extensions
	3. Find StackMaps in the Extension manager
	4. Press the button Download (or Delete & Download to update the add-on)
	5. You can transfer your maps from XMapTools or add new ones directly using add button on Stackmaps app.
	6. Select your reference image in the related popupmenu
	7. Press "select reference points" and select at least three points (clic left) on the reference image, with easy-recognisable features. When done, press clic right.
	8. Repeat 6. and 7. for the deformed image you want to stack.
	9. Press "save transformation" to compute and save the factor of transformation.
	10. Select the reference image, the deformed image and the transformation in the transformation pannel.
	11. Press "Apply" button. The transformed image will appear on the third graph and in the selection popupmenu.
	12. You can save your new map using the "Saving image (as matrix) button. The file will be saved in .txt file.
	

LOG CHANGE:
# (Dec. 2019)	ver 1.1	First release of StackMaps deployed with XMapTools 3.3.1


******************************************
MIT LICENSE - Copyright 2019 Julien Reynes

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.