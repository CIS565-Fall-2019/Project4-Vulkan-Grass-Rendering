<p align="center">
    <img src = img/demo.gif>
</p>

Vulkan Grass Rendering
================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 4**
* Jiangping Xu
  * [LinkedIn](https://www.linkedin.com/in/jiangping-xu-365b19134/)
* Tested on: Windows 10, i7-4700MQ @ 2.40GHz 8GB, GT 755M 6100MB (personal laptop)
___

This project is based on the paper [Responsive Real-Time Grass Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf)

## Features
* Forces \
_gravity_ : consists of environmental gravity (`gE`) and front gravity (`gF = (1/4) * ||gE|| * f`, where `f` is the front facing direction of the blade) \
_recovery_ : a elastic force that brings the grass blade back into equilibrium (`r = (initial_pos - curr_pos) * stiffness`) \
_wind_ : use the wind function wi(pos) = vec3(0.5, sin(pos.x + pos.y + time), 0.5) to represents the
direction and the strength of the wind at pos. There are also a directional alignment term and a height ratio term to scale the wind force according to the height and orientation of the blade.

* Orientation Culling : cull the blade when the front face direction is perpendicular to the view vector.

<p align="center">
    <div style = "padding:0px 10px 0px 40px;">
    <img src = img/ori.gif>
    </div>
</p>

* View-Frustum Culling : cull blades that are outside of the view-frustum.
* Distance Culling : cull blades that are too far.
<p align="center">
    <div style = "padding:0px 10px 0px 40px;">
    <img src = img/dis.gif>
    </div>
</p>

* Lambert shading
* LOD Tesselation : tessellate to varying levels of detail as a function of how far the grass blade is from the camera.

## Performance Analysis
### Culling
<p align="center">
    <img src = img/FPSWithDifferentCulling.png>
</p>

From the result above, we can tell frustum culling is the most effective culling mothod. Distance culling also culls out quit a lot blades. The orientation culling seems to have the least effect on the perfermance.\
Theoratically, these improvements may vary a lot according to the position of the camera.

### LOD Tesselation
When using a constant level of tesselation (the highest level used in lod tesselation), the fps is 153; when using a LOD tesselation, the fps increases to 187.





