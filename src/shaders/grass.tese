#version 450
#extension GL_ARB_separate_shader_objects : enable

#define PI 3.141592653238

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4[] in_v0;
layout(location = 1) in vec4[] in_v1;
layout(location = 2) in vec4[] in_v2;

layout(location = 0) out vec2 out_uv;
layout(location = 1) out float out_height;


void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// DONE: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

	// gather input
	vec3 v0 = in_v0[0].xyz;
	vec3 v1 = in_v1[0].xyz;
	vec3 v2 = in_v2[0].xyz;
	float width = in_v2[0].w;
	float orientation = in_v0[0].w;

	// deCasteljau's to evaluate Bezier curve
	vec3 a = mix(v0, v1, v);
	vec3 b = mix(v1, v2, v);
	vec3 c = mix(a, b, v);

	//vec3 t1 = normalize(vec3(cos(orientation + PI), 0.0, sin(orientation + PI)));
	vec3 t1 = normalize(vec3(cos(orientation), 0.0, sin(orientation))); // pointing along width of blade

	vec3 c0 = c - width * t1;
	vec3 c1 = c + width * t1;

	// for triangle shape
	float t = u + 0.5 * v - u * v;
	vec4 pos = vec4(mix(c0, c1, t), 1.0);

	// output
	out_uv = vec2(u, v);
	out_height = in_v1[0].w;;

	gl_Position = camera.proj * camera.view * pos;
}
