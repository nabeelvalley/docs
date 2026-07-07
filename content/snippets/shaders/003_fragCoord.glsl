#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    // Normalize the coordinate relative to resolution
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    gl_FragColor=vec4(st.x,st.y,1.,1.);
}
