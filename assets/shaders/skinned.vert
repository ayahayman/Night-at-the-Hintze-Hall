#version 330 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec2 tex_coord;
layout(location = 3) in vec3 normal;
layout(location = 4) in ivec4 boneIDs;
layout(location = 5) in vec4 boneWeights;

out Varyings {
    vec4 color;
    vec2 tex_coord;
    vec3 normal;
    vec3 world;
} vs_out;

// transform = VP * Model (combined MVP matrix from renderer)
uniform mat4 transform;

const int MAX_BONES = 100;
uniform mat4 boneTransforms[MAX_BONES];
uniform bool useSkinning = false;

void main() {
    vec4 localPosition = vec4(position, 1.0);
    vec3 localNormal = normal;
    
    // Apply skinning if enabled
    if (useSkinning) {
        mat4 boneTransform = mat4(0.0);
        float totalWeight = 0.0;
        
        for(int i = 0; i < 4; i++) {
            if(boneIDs[i] >= 0 && boneIDs[i] < MAX_BONES && boneWeights[i] > 0.0) {
                boneTransform += boneTransforms[boneIDs[i]] * boneWeights[i];
                totalWeight += boneWeights[i];
            }
        }
        
        // Only apply bone transformation if we have valid bone influence
        // If no valid bones, keep the original position
        if (totalWeight > 0.0) {
            localPosition = boneTransform * localPosition;
            localNormal = mat3(boneTransform) * normal;
        }
    }
    
    // Pass through color and texture coordinates
    vs_out.color = color;
    vs_out.tex_coord = tex_coord;
    vs_out.normal = normalize(localNormal);
    vs_out.world = localPosition.xyz;
    
    // Final position (transform is already VP * Model)
    gl_Position = transform * localPosition;
}
