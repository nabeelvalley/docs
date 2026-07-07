#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// do some random stuff to get a 2d random value
vec2 random2d(vec2 p){
    return fract(vec2(dot(p*sin(p)*926000.,vec2(.6125,.222))));
}

void main(){
    vec2 st=gl_FragCoord.xy/u_resolution;
    
    float grid=5.;
    
    st*=grid;
    vec2 i_st=floor(st);
    vec2 f_st=fract(st);
    
    float min_dist=1.;
    vec2 min_point=vec2(0.);
    
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            vec2 neighbor=vec2(float(x),float(y));
            
            vec2 point=random2d(i_st+neighbor)+neighbor;
            
            float dist=distance(f_st,point);
            
            // store min point and distance
            if(dist<min_dist){
                min_dist=dist;
                min_point=point;
            }
        }
    }
    
    // make the min point relative to absolute coords
    min_point+=i_st;
    
    // color for cell
    vec2 cell_color=min_point/grid;
    vec3 color=cell_color.yxx;
    
    // Show color distance lines
    color-=abs(sin(50.*min_dist))*.05;
    
    gl_FragColor=vec4(color,1.);
}