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
    st=st*6.-3.;
    
    float x=st.x;
    float t=u_time;
    
    float y=sin(x);
    
    // adding waves to create interference
    y+=sin(x*3.3+t*.125)*.12;
    y+=sin(x*4.4+t*.45)*.342;
    y+=sin(x*2.2+t*1.6)*.563;
    
    float plt=plot(st,y);
    
    vec3 color=plt*vec3(0.,1.,1.);
    
    gl_FragColor=vec4(color,1.);
}

