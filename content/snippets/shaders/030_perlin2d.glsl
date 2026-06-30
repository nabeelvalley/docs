#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random(in vec2 st){
    float a=dot(st.xy,vec2(9281.29,174.291));
    return fract(sin(a)*91287.);
}

float perlin(in vec2 st){
    vec2 i=floor(st);
    vec2 f=fract(st);
    
    // position 0,0
    float oo=random(i);
    
    // position 1,0
    float lo=random(i+vec2(1.,0.));
    
    // position 0,1
    float ol=random(i+vec2(0.,1.));
    
    // position 1,1
    float ll=random(i+vec2(1.,1.));
    
    vec2 u=smoothstep(vec2(0),vec2(1.),f);
    
    // mix the corner percentages
    return mix(oo,lo,u.x)+(ol-oo)*u.y*(1.-u.x)+
    (ll-lo)*u.x*u.y;
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float y=perlin(st*5.);
    
    vec3 color=vec3(y);
    gl_FragColor=vec4(color,1.);
}

