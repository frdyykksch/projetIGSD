#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

// A simple 2D Pseudo-random function
float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise (Interpolated)
float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y; // mix() equiv lerp()
}

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    st.x *= u_resolution.x / u_resolution.y; // Fix aspect ratio

    // Layer multiple "octaves" of noise for a misty look
    vec2 movement = vec2(u_time * 0.4, u_time * 0.2);
    float n = noise(st * 3.0 + movement);
    n += noise(st * 6.0 - movement * 0.5) * 0.5;

    // Define fog color (white/grey) and alpha based on noise
    vec3 fogColor = vec3(0.8, 0.8, 0.9);
    float density = n * 0.5; // Adjust 0.5 to make fog thicker/thinner

    gl_FragColor = vec4(fogColor, density);
}