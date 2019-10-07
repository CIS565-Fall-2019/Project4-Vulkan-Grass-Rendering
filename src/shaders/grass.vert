#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
layout(location = 0) in vec4 v0;
layout(location = 1) in vec4 v1;
layout(location = 2) in vec4 v2;
layout(location = 3) in vec4 up;

layout(location = 0) out vec4 tv0;
layout(location = 1) out vec4 tv1;
layout(location = 2) out vec4 tv2;
layout(location = 3) out vec4 tup;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
    tv0 = v0;
	tv1 = v1;
	tv2 = v2;
	tup = up;
	vec3 p = vec3(v0);
	gl_Position = model * vec4(p, 1.0);
}