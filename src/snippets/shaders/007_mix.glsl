#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=abs(sin(st.x+u_time));
    
    vec3 colorA=vec3(1.,1.,0.);
    vec3 colorB=vec3(0.,1.,1.);
    
    vec3 color=mix(colorA,colorB,y);
    
    gl_FragColor=vec4(color,1.);
}

