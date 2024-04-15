#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(float x){
    return fract(sin(x)*1000000.);
}

float plot(vec2 st,float x){
    return
    smoothstep(x-.01,x,st.y)
    -smoothstep(x,x+.01,st.y);
}

float perlin(float x){
    float i=floor(x);
    float f=fract(x);
    
    return mix(random(i),random(i+1.),f);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    st=st*4.-1.;
    
    float x=st.x;
    float t=u_time;
    
    float y=perlin(x);
    y+=perlin(x*3.3+t*.125)*.12;
    y+=perlin(x*4.4+t*.45)*.342;
    y+=perlin(x*2.2+t*1.6)*.563;
    
    float plt=plot(st,y);
    
    vec3 color=plt*vec3(0.,1.,1.);
    
    gl_FragColor=vec4(color,1.);
}

