#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

float circle(vec2 st,float r){
    vec2 center=vec2(.5);
    float dist=distance(center,st);
    float pct=step(1.-r,1.-dist);
    return pct;
}

float angle(in vec2 v){
    vec2 pos=vec2(.5)-v;
    float r=length(pos)*2.;
    float a=atan(pos.y,pos.x);
    
    return a;
}

vec2 rotate(vec2 st,in float theta){
    mat2 matrix=mat2(cos(theta),-sin(theta),
    sin(theta),cos(theta));
    
    vec2 trans=vec2(.5);
    
    st-=trans;
    st*=matrix;
    st+=trans;
    
    return st;
}

float random(float x){
    return fract(sin(x)*1000000.);
}

float perlin(float steps,float x){
    x*=steps;
    float i=floor(x);
    float f=fract(x);
    
    return mix(random(i),random(i+1.),smoothstep(0.,1.,f));
}

vec2 shift(float a,float offset){
    vec2 dir=normalize(vec2((a),(a)));
    
    vec2 norm=dir;
    
    return norm*.1;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    st=rotate(st,-PI/2.);
    
    float x=abs((u_mouse.x/u_resolution.x)-.5);
    float y=abs((u_mouse.y/u_resolution.y)-.5);
    float time=sin(u_time/5.)*10.;
    
    float r=.3+(x*.01);
    float sides=time;
    
    float a=abs(angle(st));
    float offset=perlin(a,sides)-.5;
    
    r+=offset*y*.3;
    vec3 color=vec3(circle(st,r+.005))-vec3(circle(st,r));
    
    gl_FragColor=vec4(color,1.);
}
