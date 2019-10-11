
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
layout (location = 0) in vec4 v0;
layout (location = 1) in vec4 v1;
layout (location = 2) in vec4 v2;
layout (location = 3) in vec4 up;

layout (location = 0) out vec4 v0o;
layout (location = 1) out vec4 v1o;
layout (location = 2) out vec4 v2o;
layout (location = 3) out vec4 upo;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// Write gl_Position and other shader outputs
  gl_Position = model * vec4(v0.xyz, 1);
  v0o = vec4((model * vec4(v0.xyz, 1)).xyz, v0.w);
  v1o = vec4((model * vec4(v1.xyz, 1)).xyz, v1.w);
  v2o = vec4((model * vec4(v2.xyz, 1)).xyz, v2.w);
  upo = vec4((model * vec4(up.xyz, 1)).xyz, up.w);
}
