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

float rectangle(vec2 st,float x,float y){
    float b=step(.5-y*.5,st.y);
    float l=step(.5-x*.5,st.x);
    
    float t=step(.5-y*.5,1.-st.y);
    float r=step(.5-x*.5,1.-st.x);
    
    float pct=b*l*t*r;
    return pct;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st*=5.;
    
    // returms 1. if we are in an odd numbered row
    float odd=step(1.,mod(st.y,2.));
    
    // shift the coordinate space by 0.5 if we are in an odd row
    st+=vec2(odd*.5,0.);
    
    // get the new fractional coordinate space
    st=fract(st);
    
    float c=rectangle(st,.5,.5);
    vec3 color=c*vec3(1.);
    
    gl_FragColor=vec4(color,1.);
}