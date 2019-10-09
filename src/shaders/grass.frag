#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec2 uvs;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color

    outColor = (1 - uvs.y) * vec4(0.08f, 0.47f, 0.18f, 1) + uvs.y * vec4(0.17f, 0.87f, 0.18f, 1);
}
