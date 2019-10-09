**University of Pennsylvania, CIS 565: GPU Programming and Architecture,
Vulkan Grass Rendering**

<p align="center">
  <img src="img/video2.gif">
</p>

* Grace Gilbert
  * gracelgilbert.com
* Tested on: Windows 10, i9-9900K @ 3.60GHz 64GB, GeForce RTX 2080 40860MB

## Overview
In this project I implemented a grass simulator and renderer using Vulkan. Each blade of grass is represented by a Bezier curve, which gets tessellated and shaped into a blade. I use a compute shader to perform physics calculations on the blades, adjusting the Bezier curve to apply gravity, an elastic recovery force, and wind. In this compute shader, I also cull blades to improve efficiency and remove some aliasing and flickering in the render.

## Resources
* [Responsive Real-Time Grass Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf)
* [CIS565 Vulkan samples](https://github.com/CIS565-Fall-2018/Vulkan-Samples)
* [Official Vulkan documentation](https://www.khronos.org/registry/vulkan/)
* [Vulkan tutorial](https://vulkan-tutorial.com/)
* [RenderDoc blog on Vulkan](https://renderdoc.org/vulkan-in-30-minutes.html)
* [Tessellation tutorial](http://in2gpu.com/2014/07/12/tessellation-tutorial-opengl-4-3/)

## Implementation
### Pipeline Setup
This project utilizes the Vulkan pipeline. Much of this pipeline was set up in the base code, getting to the point of a textured ground plane rendering with a simple, moveable camera setup. To render grass, I set up an additional grass descriptor set layout and descriptor set, as well as a compute descriptor set to pass in the appropriate data into the compute shader. 

The grass descriptor set passes the model matrix for each group of grass blades into the grass rendering pipeline. This model matrix transforms all of the blades, ensuring that the patch of grass blades is located in the correct position.

The compute descriptor set passes in three buffers to the compute shader. The first of these buffers is the input blades data, which holds the control points for each blade's Bezier curve, as well as the blades height, width, orientation, stiffness, and the up vector of the surface it sits on. This data is what gets modified to apply physics to the blades. Next is another buffer of blades which will contain the blades that remain after culling. This is the buffer whose data gets passed into the render pipeline, as these are the blades to be rendered. Initially, prior to implementing culling, this buffer just copied the input blades data.  Finally, the compute shader takes in a buffer that stores the number of remaining blades. Each non-culled blade increments this number using an atomic add. This number ensures that we render the right number of blades each frame. 

The overall path of the pipeline is first the compute shader, where physics and culling are performed. The output data then goes to the grass vertex shader, which transforms the control points with the blade's model matrix. Then the tessellation control shader determines how finely to tesselate the blade. The tessellation evaluation shader shapes the tessellated blade. Finally, the fragment shader shades the blades, which are then rendered to the screen.

### Blade Tessellation and Rendering
Each blade of grass is represented as a Bezier curve with three control points, `v0`, `v1`, and `v2`, where `v0` is the base position of the blade. `v1` always lies directly above `v0`, and `v2` is what we apply forces to to animate the grass. There is also an up vector, defining the up direcction of the surface the blades sit on. The vectors are all 4D vectors, where the 4th element holds another piece of information: height, width, stiffness, and orientation. The following image represents the blade model described:

![](img/blade_model.jpg)

The vectors get passed into the vertex shader, where they are transformed into model space using the model matrix of the group of blades. The base position, `v0`, gets passed as the gl_Position into the tessellation control shader. The control shader sets the tessellation levels and passes along the control points and gl_Position into the tessellation evaluation shader. The tessellation levels control how subdivided the tessellation will be, which affects how smooth the curves in the grass blades will be.

The tessellation evaluation shader is where we shape the blades to curve along their Bezier curve and to have a grass blade shape along their width. To shape the blade along the Bezier curve defined by the control points, we perform a series of interpolations, following De Casteljau's algorithm:

![](img/BezierEquations.PNG)

We then use these interpolated values to find the final position of our current point in the tessellation:

![](img/BezierPositionEquation.PNG)

The t value in the above equation determines the shape of the blade of grass, acheiving any of the shapes pictures below:

![](img/BladeShapes.PNG)

Finally, this position is projected into screen space with the view projection matrix.

The last step of the blade rendering is the fragment shader. This shader applies a gradient to the blades, making them dark green at their base and light green at the tips. This shading uses the height at the current portion of the blade. This height is a mix between the world space height and the individual blade space height. The world space height ensures that parts of the blades at the same height will have similar luminance. The blade space height ensures that even shorter blades still have some light green at their tips. The mixing of these two height spaces gives a more natural, varied look to the grass. 

I initially tried using lambertian shading based on the angle of the blade of grass, but this caused the color distrubition to be too varied. Because each blade is a flat plane, the orientation dramatically affects the lighting on it, causing all blades to have different tones of green, which does not look realistic. 

### Physics
The process of applying physics to the blades of grass involves calculating all forces that act upon the blades, and then updating the Bezier control points according to these forces. We are applying forces onto the third control point, `v2`, however there are measures we must take to ensure that when we apply the forces, we maintain certain properties: the blade must not fall through the ground plane, the length of the curved blade must be the same as the height of the blade to preserve length, and `v1` must be updated in relation to `v2`. 

We start by finding the updated position for `v2`, ensuring that it is above ground:

![](img/CurveUpdateStage1.PNG)

To find the updated position of `v1`, which must always be directly above the base of the blade, we find the length of the projection of the blade onto the ground and use this to find `v1`:

![](img/CurveUpdateStage2.PNG)

![](img/CurveUpdateStage3.PNG)

The final step is to ensure that the length of the curved blade is not longer than the height of the straight blade. We first evaluation the length of the Bezier curve:

![](img/CurveUpdateStage4.PNG)

Finally, we use this length and the height of the blade to set the final updated control points:

![](img/CurveUpdateStage5.PNG)

Below I describe how we calculate each of the forces that act on the blades of grass.

#### Gravity
To apply gravity onto the grass blades, we start with a direction and magnitude for gravity, which we use to find the environmental gravity:
```
GravtityDirection = (0, -1, 0)
GravityMagnitude = 9.8
GravityEnvironmental = (0, -9.8, 0)
```
Because blades are represented as flat planes, they can only fall in one direction, the direction that they are facing. To find this direction, I converted the orientation of the blade into a direction vector with simple trigonometry:
```
BladeFacingDirection = (cos(orientation), 0, sin(orientation))
```
We then calculate how much gravity contributes with respect to this facing direction:
```
GravityFront = (1/4) * length(GravityEnvironmental) * BladeFacingDirection
```
Finally, the total force of gravity is the sum of the environmental gravity and the front facing gravity:
```
GravityForce = GravityEnvironmental + GravityFront
```
#### Recovery
Blades of grass have some elastic stiffness to them, allowing them to remain mostly upright even in the presence of gravity. To represent this, we add a recovery force to counter the gravitational force. We use Hooke's law to simulate this.

The recovery force is found by comparing the current position of `v2`, the third control point, to its original position at the start of the simulation, `iv2`. Knowing both `v2` and `iv2`, the recovery force is as follows: 
```
r = (iv2 - v2) * BladeStiffness.
```
#### Wind
The final force is the wind force. The wind force on each blade is determined by a function of the position of the base of each blade, wi(v0). This function defines the direction and strength of the wind at each point in space. For my wind functions, I used combinations of sinusoidal function and Fractal Brownian Motion noise. The noise breaks up some of the sinusoidal patterns in the wind.  

We next need to see how the wind affects the blade based on its the blade's orientation. Note that a wind force acting perpendicular to the front face of the blade will have no affect on that blade, as it can only bend along its front face. The affect of the wind becomes stronger as the direction and the front face become more aligned. The calculation for the final wind force is the following: 

![](img/WindCalculations.PNG)

![](img/FinalWindForce.PNG)

### Culling
#### Orientation
#### Frustum
#### Distance
## Performance Analysis
## Bloopers





### Culling tests

Although we need to simulate forces on every grass blade at every frame, there are many blades that we won't need to render
due to a variety of reasons. Here are some heuristics we can use to cull blades that won't contribute positively to a given frame.

#### Orientation culling

Consider the scenario in which the front face direction of the grass blade is perpendicular to the view vector. Since our grass blades
won't have width, we will end up trying to render parts of the grass that are actually smaller than the size of a pixel. This could
lead to aliasing artifacts.

In order to remedy this, we can cull these blades! Simply do a dot product test to see if the view vector and front face direction of
the blade are perpendicular. The paper uses a threshold value of `0.9` to cull, but feel free to use what you think looks best.

#### View-frustum culling

We also want to cull blades that are outside of the view-frustum, considering they won't show up in the frame anyway. To determine if
a grass blade is in the view-frustum, we want to compare the visibility of three points: `v0, v2, and m`, where `m = (1/4)v0 * (1/2)v1 * (1/4)v2`.
Notice that we aren't using `v1` for the visibility test. This is because the `v1` is a Bezier guide that doesn't represent a position on the grass blade.
We instead use `m` to approximate the midpoint of our Bezier curve.

If all three points are outside of the view-frustum, we will cull the grass blade. The paper uses a tolerance value for this test so that we are culling
blades a little more conservatively. This can help with cases in which the Bezier curve is technically not visible, but we might be able to see the blade
if we consider its width.

#### Distance culling

Similarly to orientation culling, we can end up with grass blades that at large distances are smaller than the size of a pixel. This could lead to additional
artifacts in our renders. In this case, we can cull grass blades as a function of their distance from the camera.

You are free to define two parameters here.
* A max distance afterwhich all grass blades will be culled.
* A number of buckets to place grass blades between the camera and max distance into.

Define a function such that the grass blades in the bucket closest to the camera are kept while an increasing number of grass blades
are culled with each farther bucket.


### Tessellating Bezier curves into grass blades

** Extra Credit**: Tessellate to varying levels of detail as a function of how far the grass blade is from the camera. For example, if the blade is very far, only generate four vertices in the tessellation control shader.


### Performance Analysis

The performance analysis is where you will investigate how...
* Your renderer handles varying numbers of grass blades
* The improvement you get by culling using each of the three culling tests

## Submit

Open a GitHub pull request so that we can see that you have finished.
The title should be "Project 6: YOUR NAME".
The template of the comment section of your pull request is attached below, you can do some copy and paste:  

* [Repo Link](https://link-to-your-repo)
* (Briefly) Mentions features that you've completed. Especially those bells and whistles you want to highlight
    * Feature 0
    * Feature 1
    * ...
* Feedback on the project itself, if any.
