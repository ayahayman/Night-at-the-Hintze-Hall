#version 330 core

in Varyings {
    vec4 color;
    vec2 tex_coord;
    vec3 normal;
    vec3 world;
} fs_in;

out vec4 frag_color;

uniform sampler2D tex;

void main() {
    // Simple textured output, same as textured.frag
    frag_color = texture(tex, fs_in.tex_coord);
}
