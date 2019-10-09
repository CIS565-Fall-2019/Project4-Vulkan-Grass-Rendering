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
### Physics
#### Gravity
#### Recovery
#### Wind
### Culling
#### Orientation
#### Frustum
#### Distance
## Performance Analysis
## Bloopers




## Requirements

**Ask on the mailing list for any clarifications.**

In this project, you are given the following code:

* The basic setup for a Vulkan project, including the swapchain, physical device, logical device, and the pipelines described above.
* Structs for some of the uniform buffers you will be using.
* Some buffer creation utility functions.
* A simple interactive camera using the mouse. 

You need to implement the following features/pipeline stages:

* Compute shader (`shaders/compute.comp`)
* Grass pipeline stages
  * Vertex shader (`shaders/grass.vert')
  * Tessellation control shader (`shaders/grass.tesc`)
  * Tessellation evaluation shader (`shaders/grass.tese`)
  * Fragment shader (`shaders/grass.frag`)
* Binding of any extra descriptors you may need

See below for more guidance.

## Base Code Tour

Areas that you need to complete are
marked with a `TODO` comment. Functions that are useful
for reference are marked with the comment `CHECKITOUT`.

* `src/main.cpp` is the entry point of our application.
* `src/Instance.cpp` sets up the application state, initializes the Vulkan library, and contains functions that will create our
physical and logical device handles.
* `src/Device.cpp` manages the logical device and sets up the queues that our command buffers will be submitted to.
* `src/Renderer.cpp` contains most of the rendering implementation, including Vulkan setup and resource creation. You will 
likely have to make changes to this file in order to support changes to your pipelines.
* `src/Camera.cpp` manages the camera state.
* `src/Model.cpp` manages the state of the model that grass will be created on. Currently a plane is hardcoded, but feel free to 
update this with arbitrary model loading!
* `src/Blades.cpp` creates the control points corresponding to the grass blades. There are many parameters that you can play with
here that will change the behavior of your rendered grass blades.
* `src/Scene.cpp` manages the scene state, including the model, blades, and simualtion time.
* `src/BufferUtils.cpp` provides helper functions for creating buffers to be used as descriptors.

We left out descriptions for a couple files that you likely won't have to modify. Feel free to investigate them to understand their 
importance within the scope of the project.

## Grass Rendering

This project is an implementation of the paper, [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf).
Please make sure to use this paper as a primary resource while implementing your grass renderers. It does a great job of explaining
the key algorithms and math you will be using. Below is a brief description of the different components in chronological order of how your renderer will
execute, but feel free to develop the components in whatever order you prefer.

We recommend starting with trying to display the grass blades without any forces on them before trying to add any forces on the blades themselves. Here is an example of what that may look like:

![](img/grass_basic.gif)

### Representing Grass as Bezier Curves

In this project, grass blades will be represented as Bezier curves while performing physics calculations and culling operations. 
Each Bezier curve has three control points.
* `v0`: the position of the grass blade on the geomtry
* `v1`: a Bezier curve guide that is always "above" `v0` with respect to the grass blade's up vector (explained soon)
* `v2`: a physical guide for which we simulate forces on

We also need to store per-blade characteristics that will help us simulate and tessellate our grass blades correctly.
* `up`: the blade's up vector, which corresponds to the normal of the geometry that the grass blade resides on at `v0`
* Orientation: the orientation of the grass blade's face
* Height: the height of the grass blade
* Width: the width of the grass blade's face
* Stiffness coefficient: the stiffness of our grass blade, which will affect the force computations on our blade

We can pack all this data into four `vec4`s, such that `v0.w` holds orientation, `v1.w` holds height, `v2.w` holds width, and 
`up.w` holds the stiffness coefficient.

![](img/blade_model.jpg)

### Simulating Forces

In this project, you will be simulating forces on grass blades while they are still Bezier curves. This will be done in a compute
shader using the compute pipeline that has been created for you. Remember that `v2` is our physical guide, so we will be
applying transformations to `v2` initially, then correcting for potential errors. We will finally update `v1` to maintain the appropriate
length of our grass blade.

#### Binding Resources

In order to update the state of your grass blades on every frame, you will need to create a storage buffer to maintain the grass data.
You will also need to pass information about how much time has passed in the simulation and the time since the last frame. To do this,
you can extend or create descriptor sets that will be bound to the compute pipeline.

#### Gravity

Given a gravity direction, `D.xyz`, and the magnitude of acceleration, `D.w`, we can compute the environmental gravity in
our scene as `gE = normalize(D.xyz) * D.w`.

We then determine the contribution of the gravity with respect to the front facing direction of the blade, `f`, 
as a term called the "front gravity". Front gravity is computed as `gF = (1/4) * ||gE|| * f`.

We can then determine the total gravity on the grass blade as `g = gE + gF`.

#### Recovery

Recovery corresponds to the counter-force that brings our grass blade back into equilibrium. This is derived in the paper using Hooke's law.
In order to determine the recovery force, we need to compare the current position of `v2` to its original position before
simulation started, `iv2`. At the beginning of our simulation, `v1` and `v2` are initialized to be a distance of the blade height along the `up` vector.

Once we have `iv2`, we can compute the recovery forces as `r = (iv2 - v2) * stiffness`.

#### Wind

In order to simulate wind, you are at liberty to create any wind function you want! In order to have something interesting,
you can make the function depend on the position of `v0` and a function that changes with time. Consider using some combination
of sine or cosine functions.

Your wind function will determine a wind direction that is affecting the blade, but it is also worth noting that wind has a larger impact on
grass blades whose forward directions are parallel to the wind direction. The paper describes this as a "wind alignment" term. We won't go 
over the exact math here, but use the paper as a reference when implementing this. It does a great job of explaining this!

Once you have a wind direction and a wind alignment term, your total wind force (`w`) will be `windDirection * windAlignment`.

#### Total force

We can then determine a translation for `v2` based on the forces as `tv2 = (gravity + recovery + wind) * deltaTime`. However, we can't simply
apply this translation and expect the simulation to be robust. Our forces might push `v2` under the ground! Similarly, moving `v2` but leaving
`v1` in the same position will cause our grass blade to change length, which doesn't make sense.

Read section 5.2 of the paper in order to learn how to determine the corrected final positions for `v1` and `v2`. 

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

In this project, you should pass in each Bezier curve as a single patch to be processed by your grass graphics pipeline. You will tessellate this patch into 
a quad with a shape of your choosing (as long as it looks sufficiently like grass of course). The paper has some examples of grass shapes you can use as inspiration.

In the tessellation control shader, specify the amount of tessellation you want to occur. Remember that you need to provide enough detail to create the curvature of a grass blade.

The generated vertices will be passed to the tessellation evaluation shader, where you will place the vertices in world space, respecting the width, height, and orientation information
of each blade. Once you have determined the world space position of each vector, make sure to set the output `gl_Position` in clip space!

** Extra Credit**: Tessellate to varying levels of detail as a function of how far the grass blade is from the camera. For example, if the blade is very far, only generate four vertices in the tessellation control shader.

To build more intuition on how tessellation works, I highly recommend playing with the [helloTessellation sample](https://github.com/CIS565-Fall-2018/Vulkan-Samples/tree/master/samples/5_helloTessellation)
and reading this [tutorial on tessellation](http://in2gpu.com/2014/07/12/tessellation-tutorial-opengl-4-3/).



## README

* A brief description of the project and the specific features you implemented.
* GIFs of your project in its different stages with the different features being added incrementally.
* A performance analysis (described below).

### Performance Analysis

The performance analysis is where you will investigate how...
* Your renderer handles varying numbers of grass blades
* The improvement you get by culling using each of the three culling tests

## Submit

If you have modified any of the `CMakeLists.txt` files at all (aside from the
list of `SOURCE_FILES`), mentions it explicity.
Beware of any build issues discussed on the Google Group.

Open a GitHub pull request so that we can see that you have finished.
The title should be "Project 6: YOUR NAME".
The template of the comment section of your pull request is attached below, you can do some copy and paste:  

* [Repo Link](https://link-to-your-repo)
* (Briefly) Mentions features that you've completed. Especially those bells and whistles you want to highlight
    * Feature 0
    * Feature 1
    * ...
* Feedback on the project itself, if any.
