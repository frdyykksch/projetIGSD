#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform float u_nightMode;

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm (vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

uniform sampler2D texture;
varying vec4 vertTexCoord;

void main() {
    vec4 sceneColor = texture2D(texture, vertTexCoord.st);

    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    st.x *= u_resolution.x / u_resolution.y;
    
    float n = fbm(st + 0.15 * u_time);
    float density = n * 0.5;
    
    vec3 dayFog = vec3(0.85, 0.85, 0.9);
    vec3 nightFog = vec3(0.05, 0.05, 0.1);
    vec3 fogColor = mix(dayFog, nightFog, u_nightMode);

    vec3 finalRGB = mix(sceneColor.rgb, fogColor, density);

    gl_FragColor = vec4(finalRGB, 1.0);
}