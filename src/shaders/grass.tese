#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4[] in_v0;
layout(location = 1) in vec4[] in_v1;
layout(location = 2) in vec4[] in_v2;
layout(location = 3) in vec4[] in_up;

layout(location = 0) out vec4 out_nor;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	vec3 v0 = in_v0[gl_PrimitiveID].xyz;
	vec3 v1 = in_v1[gl_PrimitiveID].xyz;
	vec3 v2 = in_v2[gl_PrimitiveID].xyz;
	float width = in_v2[gl_PrimitiveID].w;
	float orientation = in_v0[gl_PrimitiveID].w;

	// todo replace these with lerps
	vec3 a = v0 + v * (v1 - v0);
	vec3 b = v1 + v * (v2 - v1);
	vec3 c = a + v * (b - a);
	float PI = 3.14159;

	vec3 t1 = normalize(vec3(cos(orientation + PI), sin(orientation + PI), 0.0));
	vec3 t0 = normalize(b - a);
	vec3 n = normalize(cross(t0, t1)); 
	out_nor = vec4(n, 0.0);

	vec3 c0 = c - width * t1;
	vec3 c1 = c + width * t1;

	// for triangle shape
	float t = u + 0.5 * v - u * v;
	vec4 pos = vec4(vec3((1.0 - t) * c0 + t * c1), 1.0);

	gl_Position = camera.proj * camera.view * pos;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

}
