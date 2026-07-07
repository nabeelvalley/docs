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

float random(float x){
    return fract(sin(x)*999999.);
}

float perlin(float steps,float x){
    x*=steps;
    float i=floor(x);
    float f=fract(x);
    
    return mix(random(i),random(i+1.),smoothstep(0.,1.,f));
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=perlin(st.x,10.);
    
    vec3 color=vec3(plot(st,y));
    gl_FragColor=vec4(color,1.);
}