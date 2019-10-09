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
    tv0 =  model * vec4(vec3(v0), 1.0);
	tv0.w = v0.w;
	tv1 =  model * vec4(vec3(v1), 1.0);
	tv1.w = v1.w;
	tv2 =  model * vec4(vec3(v2), 1.0);
	tv2.w = v2.w; 
	tup =  model * vec4(vec3(up), 0.0);
	tup.w = up.w;
	gl_Position = model * vec4(vec3(v0), 1.0);
}
