#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float plot(vec2 st,float x){
    return
    smoothstep(x-.01,x,st.y)
    -smoothstep(x,x+.01,st.y);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=fract(sin(st.x)*1000000.);
    vec3 color=vec3(y);
    
    gl_FragColor=vec4(color,1.);
}