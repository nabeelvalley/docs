#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(vec2 st){
    float a=dot(st.xy,vec2(1000,1000));
    return fract(sin(a)*1000000.);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    vec3 color=vec3(random(st));
    gl_FragColor=vec4(color,1.);
}