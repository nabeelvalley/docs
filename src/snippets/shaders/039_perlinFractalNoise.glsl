#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(float x){
    return fract(sin(x)*999999.);
}

float plot(vec2 st,float x){
    return
    smoothstep(x-.01,x,st.y)
    -smoothstep(x,x+.01,st.y);
}

float perlin(float x){
    x*=5.;
    float i=floor(x);
    float f=fract(x);
    
    return mix(random(i),random(i+1.),smoothstep(0.,1.,f));
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    const int octaves=8;
    float lacunarity=2.;
    float gain=.5;
    
    float x=st.x;
    float t=u_time*.2;
    
    // initial values
    float amplitude=.5;
    float freq=1.;
    float y=0.;
    
    for(int i=0;i<octaves;i++){
        y+=amplitude*perlin(freq*x+t);
        freq*=lacunarity;
        amplitude*=gain;
    }
    
    float plt=plot(st,y);
    
    vec3 color=plt*vec3(0.,1.,1.);
    
    gl_FragColor=vec4(color,1.);
}
