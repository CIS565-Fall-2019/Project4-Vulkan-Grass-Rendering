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

layout(location = 0) out vec4 normal;
layout(location = 1) out vec4 lightDir;
layout(location = 2) out float height;

const float PI = 3.141592654;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;
	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	// Read in inputs
	vec4 currv0 = in_v0[0];
	vec4 currv1 = in_v1[0];
	vec4 currv2 = in_v2[0];
	vec4 currUp = in_up[0];

	// Get vec3 parts of inputs
	vec3 v0 = vec3(currv0);
	vec3 v1 = vec3(currv1);
	vec3 v2 = vec3(currv2);
	vec3 up = vec3(currUp);

	// Convert orientation into direction
	vec3 t1 = normalize(vec3(cos(currv0.w + PI), 0.f, sin(currv0.w + PI)));
	   
	// Perform interpolations to calculate position
	vec3 a = v0 + v * (v1 - v0);
	vec3 b = v1 + v * (v2 - v1);
	vec3 c = a + v * (b - a);
	vec3 c0 = c - currv2.w * t1;
	vec3 c1 = c + currv2.w * t1;
	vec3 t0 = (b - a) / (length(b - a));
	vec3 n = cross(t0, t1) / length(cross(t0, t1));

	normal = normalize(vec4(n, 0.f));
	float t = u - u * v * v;
//	t = u + 0.5 * v - u * v;

	vec3 pos = (1.f - t) * c0 + t * c1;

	// Set transformed position and output data
	gl_Position = camera.proj * camera.view * vec4(pos, 1.0);
	lightDir = normalize(gl_Position - vec4(0.0, 5.0, 0.0, 1.0));
	height = mix(v, pos.y / 4.0, 0.8);
}
