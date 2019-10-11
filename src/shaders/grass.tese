#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
// Understanding the pipeline: Inputs are from grass.tesc
layout(location = 0) in vec4 v0[]; // w = orientation ***
layout(location = 1) in vec4 v1[]; // w = height
layout(location = 2) in vec4 v2[]; // w = width ***
layout(location = 3) in vec4 up[]; // w = stiffness

// Outputs are passed into grass.frag
layout(location = 0) out vec4 pos;
layout(location = 1) out vec4 norm;
layout(location = 2) out float hInterp; // horizontal interpolation value
layout(location = 3) out float vInterp; // vertical

void main() {
    float u = gl_TessCoord.x; // Interpolation along width of blade
    float v = gl_TessCoord.y; // Interpolation along height
	hInterp = u;
	vInterp = v;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	// Using De Casteljau's algorithm outline from Klemens Jahrmann's Grass Rendering paper
	vec3 bitangent = vec3(sin(v0[0].w), 0.f, cos(v0[0].w)); // t1

	// Auxiliary vectors and curve points. LERP time (vertical)
	vec3 a = v0[0].xyz + v * (v1[0].xyz - v0[0].xyz);
	vec3 b = v1[0].xyz + v * (v2[0].xyz - v1[0].xyz);
	vec3 c = a + v * (b - a);

	// Two resulting curvepoints that span width of the blade:
	vec3 c0 = c - v2[0].w * bitangent;
	vec3 c1 = c + v2[0].w * bitangent;

	vec3 tangent = (b - a) / length(b - a);	// t0
	norm = vec4(cross(tangent, bitangent) / length(cross(tangent, bitangent)), 0.f);

	// Basic shape: quad + triangle shape (may add more later)
	// Horizontal LERP time
	float t = u + 0.5f * v - u * v;
	// Quadratic option: float t = u - u * v * v;  // Plain quad: t = u;
	pos = vec4((1.f - t) * c0 + t * c1, 1.f);

	gl_Position = camera.proj * camera.view * pos;
}
