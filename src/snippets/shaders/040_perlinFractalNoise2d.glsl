#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(in vec2 st){
    float a=dot(st.xy,vec2(12.29,1.291));
    return fract(sin(a)*1125163.);
}

float perlin(in vec2 st){
    vec2 i=floor(st);
    vec2 f=fract(st);
    
    float oo=random(i);
    float lo=random(i+vec2(1.,0.));
    float ol=random(i+vec2(0.,1.));
    float ll=random(i+vec2(1.,1.));
    
    vec2 u=smoothstep(vec2(0),vec2(1.),f);
    
    return mix(oo,lo,u.x)+(ol-oo)*u.y*(1.-u.x)+
    (ll-lo)*u.x*u.y;
}

float fbm(in vec2 st,float lacunarity,float gain){
    const int octaves=8;
    
    float x=st.x;
    float t=u_time*.5;
    
    // initial values
    float amplitude=.5;
    float freq=4.;
    float y=0.;
    
    for(int i=0;i<octaves;i++){
        y+=amplitude*perlin(freq*st+t);
        freq*=lacunarity;
        amplitude*=gain;
    }
    
    return y;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=fbm(st,2.,.5);
    
    vec3 color=vec3(y);
    
    gl_FragColor=vec4(color,1.);
}
