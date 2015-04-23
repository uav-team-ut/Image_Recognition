README.txt
----------
colorShapes2D-8words-300images is a set of a total of 300 images, composed of two types of
shapes (circle / box), each affected by seven word descriptions, which correspond to:

vpos: bottom (20,1) / middle (50,1) / top (80,1) -> [0,100]
hpos: left (20,1) / middle (50,1) / right (80,1) -> [0,100]
brightness: dark (120,2.55) / light (245,2.55) -> [0,255]
hue: red (0,1.8) / green (60,1.8) / green (120,1.8) -> [0,180] (cyclic)
size: small (8,1) / big (15,1) -> [0,100]
aspect: fat (+2,1)(-2,1) / thin (-2,1)(+2,1) -> [0,100][0,100] (bidimentional)
tilt: tilted (15,0.15) / straight (0,0.15) -> [0,15]

where all distr ~ N(mean,std_dev). It can be seen that all means are in specific ranges
[..., ...] and std_devs correspond to 1% of this range.

Thus the name format includes the 7 descriptors, the type, and a unique identifier:
vpos_hpos_brightness_hue_size_aspect_tilt_type_id.ppm

These images were generated using -r 2097 of
$XGNITIVE_ROOT/main/src/modules/imgGenerator, mainly made by Santiago Morante to generate
.png files using opencv, and passed through mogrify to convert to .ppm.

Legal
-----
Copyright: 2013 (C) Universidad Carlos III de Madrid

Authors: <a href="http://roboticslab.uc3m.es/roboticslab/persona_publ.php?id_pers=72">Juan G. Victores</a>,
<a href="http://www.mendeley.com/profiles/santiago-morante-cendrero/">Santiago Morante</a>

CopyPolicy: This dataset is available under the Creative Commons Attribution License
(http://creativecommons.org/licenses/by/3.0/).

