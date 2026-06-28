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
    
    float y=abs(sin(st.x+u_time));
    
    float plt=plot(st,y);
    
    vec3 color=plt*vec3(0.,1.,1.);
    
    gl_FragColor=vec4(color,1.);
}

