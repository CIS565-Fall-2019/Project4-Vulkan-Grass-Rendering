#version 450
#extension GL_ARB_separate_shader_objects : enable

#define PI 3.141592653238

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
layout(location = 1) out vec4 out_lightDir;
layout(location = 2) out vec2 out_uv;


void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	vec3 v0 = in_v0[0].xyz;
	vec3 v1 = in_v1[0].xyz;
	vec3 v2 = in_v2[0].xyz;// + vec3(0.1, 0.1, 0.0);
	float width = in_v2[0].w;
	float orientation = in_v0[0].w;

	vec3 a = mix(v0, v1, v);
	vec3 b = mix(v1, v2, v);
	vec3 c = mix(a, b, v);

	vec3 t1 = normalize(vec3(cos(orientation + PI), 0.0, sin(orientation + PI)));
	vec3 t0 = normalize(b - a);
	vec3 n = normalize(cross(t0, t1)); 
	out_nor = vec4(n, 0.0);

	vec3 c0 = c - width * t1;
	vec3 c1 = c + width * t1;

	// for triangle shape
	float t = u + 0.5 * v - u * v;
	vec4 pos = vec4(vec3(mix(c0, c1, t)), 1.0);

	pos = camera.proj * camera.view * pos;

	vec4 lightPos = vec4(0.0, 5.0, 0.0, 1.0);
	out_lightDir = lightPos - pos;

	out_uv = vec2(u, v);

	//pos = camera.proj * camera.view * pos;

	gl_Position = pos;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

}
