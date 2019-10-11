#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Declare tessellation evaluation shader inputs and outputs
layout (location = 0) in vec4 v0i[];
layout (location = 1) in vec4 v1i[];
layout (location = 2) in vec4 v2i[];
layout (location = 3) in vec4 upi[];

layout (location = 0) out vec3 n;
layout (location = 1) out vec2 uv;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	  // Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    float orientation = v0i[0].w;
    float width = v2i[0].w;
    
    vec3 v0 = v0i[0].xyz;
    vec3 v1 = v1i[0].xyz;
    vec3 v2 = v2i[0].xyz;
    vec3 up = upi[0].xyz;

    vec3 forward = normalize(vec3(sin(orientation), 0, cos(orientation)));
    vec3 t1 = normalize(cross(up, forward));

    vec3 a = v0 + v * (v1 - v0);
    vec3 b = v1 + v * (v2 - v1);
    vec3 c = a + v * (b - a);
    vec3 c0 = c - width * t1;
    vec3 c1 = c + width * t1;
    vec3 t0 = normalize(b - a);
    n = normalize(cross(t1, t0));
    uv = vec2(u, v);

    float t = u - u * v * v;
    vec4 p = vec4((1 - t) * c0 + t * c1, 1); 
    gl_Position = camera.proj * camera.view * p;
}
