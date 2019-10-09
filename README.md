# Vulkan Grass Rendering
**University of Pennsylvania, CIS 565: GPU Programming and Architecture,
Project 4**

Caroline Lachanski: [LinkedIn](https://www.linkedin.com/in/caroline-lachanski/), [personal website](http://carolinelachanski.com/)

Tested on: Windows 10, i5-6500 @ 3.20GHz 16GB, GTX 1660 (personal computer)

// header image here

## Project Description

The goal of this project was to utilize Vulkan to implement a realtime grass simulation and render, heavily based on this paper: [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf). For most of the pipeline, each blade of grass is represented as three control points (v0, v1, and v2) of a Bezier curve. Forces are applied on these points in the compute shader, as is culling. In the tessellation evaluation shader, this curve is evaluated using deCasteljau's.

## Features

### Forces

#### Gravity

#### Recovery

#### Wind

#### Simulation Correction

### Culling

#### Orientation Culling

![](img/orientationCullingVis.gif)

#### View Frustum Culling

![](img/frustumCullingVis.gif)

#### Distance Culling

![](img/distanceCullingVis.gif)

## Analysis

## Bloopers

It took a *long* time before I had any grass appearing at all, so I was really happy to get to this stage:

![](img/projectFinishedNoMoreWorkNeeded.PNG)

(I was indexing into my input arrays in the evaluation shader using gl_PrimitiveID, but since each array was of length 1, only one blade would draw)

![](img/turnTheBassDown.gif)

![](img/uh.gif)
