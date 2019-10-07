#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation control shader inputs and outputs
//inputs from vert shader
layout (location = 0) in vec4 tesc_v1[];
layout (location = 1) in vec4 tesc_v2[];
layout (location = 2) in vec4 tesc_up[];
layout (location = 3) in vec4 tesc_front[];
layout (location = 4) in vec4 tesc_widthdir[];

//output to evaluation shader
layout (location = 0) patch out vec4 tese_v1;
layout (location = 1) patch out vec4 tese_v2;
layout (location = 2) patch out vec4 tese_up;
layout (location = 3) patch out vec4 tese_front;
layout (location = 4) patch out vec4 tese_widthdir;
//layout (location = 0) out vec4 tese_v1;
//layout (location = 1) out vec4 tese_v2;
//layout (location = 2) out vec4 tese_up;
//layout (location = 3) out vec4 tese_forward;


void main() {
	// Don't move the origin location of the patch
	//world coord
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;



	// TODO: Write any shader outputs
	// pass through the passed in vec4
	tese_v1 = tesc_v1[0];
	tese_v2 = tesc_v2[0];
	tese_up = tesc_up[0];
	tese_front = tesc_front[0];
	tese_widthdir = tesc_widthdir[0];


	// TODO: Set level of tesselation
    
	//tessellation on multiple levels depending on depth
	//compute the depth in ndc
	//https://docs.google.com/presentation/d/1YkDE7YAqoffC9wUmDxFo9WZjiLqWI5SlQRojOeCBPGs/edit#slide=id.g2492ec6f45_0_342 560 slides
	//get the world position of v0 of this blade from gl_in
	vec4 v0_world = gl_in[gl_InvocationID].gl_Position;
	v0_world.w = 1.0; //it is a point
	//transform from world space to projection space
	vec4 v0_proj = camera.proj * camera.view * v0_world;
	//map to screen space
	v0_proj /= v0_proj.w;
	//get depth in normalized screen space
	//float depth = clamp(v0_proj.z, 0.0, 1.0);
	float depth = v0_proj.z;

	float tess_height_min = 3.0;
	float tess_height_max = 8.0;
	float tess_width = 2.0;

	//divide depth into 3 layers
	float tess_height = mix(tess_height_max, tess_height_min, depth);
	//float tessLevel = tessLevelmax;

	// TODO: Set level of tesselation
     gl_TessLevelInner[0] = tess_width; //horizontal
     gl_TessLevelInner[1] = tess_height; //vertical

     gl_TessLevelOuter[0] = tess_height; //vert 0 - 3
     gl_TessLevelOuter[1] = tess_width;// vert 3 - 2
     gl_TessLevelOuter[2] = tess_height; //vert 2 - 1
     gl_TessLevelOuter[3] = tess_width; // vert 1 -0
}
