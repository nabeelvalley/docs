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
    return fract(sin(x)*1000000.);
}

float perlin(float steps,float x){
    x*=steps;
    float i=floor(x);
    float f=fract(x);
    
    // this is the same a as smoothstep
    float u=f*f*(3.-2.*f);
    
    return mix(random(i),random(i+1.),u);
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=perlin(st.x,10.);
    
    vec3 color=vec3(plot(st,y));
    gl_FragColor=vec4(color,1.);
}

