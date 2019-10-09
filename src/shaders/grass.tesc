#version 450
#extension GL_ARB_separate_shader_objects : enable
layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
	vec3 pos;
} camera;

// TODO: Declare tessellation control shader inputs and outputs
layout(location = 0) in vec4 tv0[];
layout(location = 1) in vec4 tv1[];
layout(location = 2) in vec4 tv2[];
layout(location = 3) in vec4 tup[];

layout(location = 0) patch out vec4 se_v0;
layout(location = 1) patch out vec4 se_v1;
layout(location = 2) patch out vec4 se_v2;
layout(location = 3) patch out vec4 se_up;

//http://ogldev.atspace.co.uk/www/tutorial30/tutorial30.html
void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs
	se_v0 = tv0[gl_InvocationID];
	se_v1 = tv1[gl_InvocationID];
	se_v2 = tv2[gl_InvocationID];
	se_up = tup[gl_InvocationID];

	// Tess depend on the depth of origin location
	vec4 pos = gl_in[gl_InvocationID].gl_Position;
	pos.w = 1.0;
	pos = camera.proj * camera.view * pos;
	//ndc
	vec3 ndc_p = pos.xyz / pos.w;

	float depth = clamp(ndc_p.z, 0.0, 1.0);

	int max_level = 3;
	int level = max_level - int(depth / 0.5);//0-6->7-1
	level = max(1, level);

	//for bottom and up
	int max_level2 = 2;//4
	int level2 = max_level2 - int(depth / 0.5);//0-3->4-1
	level2 = max(1, level2);

	// TODO: Set level of tesselation
    gl_TessLevelInner[0] = level2;
    gl_TessLevelInner[1] = level2;

    gl_TessLevelOuter[0] = level;//right
    gl_TessLevelOuter[1] = level2;//up
    gl_TessLevelOuter[2] = level;//left
    gl_TessLevelOuter[3] = level2;//down
}

