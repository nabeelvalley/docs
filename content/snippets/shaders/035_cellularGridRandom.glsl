#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Do some random stuff to get a 2d random value
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
    for(int y=-1;y<=1;y++){
        for(int x=-1;x<=1;x++){
            // Get the root of the neighbor
            vec2 neighbor=vec2(float(x),float(y));
            
            // Define a center as the integer part + the neighbor
            // This will be the same for all values in a grid
            vec2 point=random2d(i_st+neighbor)+neighbor;
            
            // Get the distance from the neighbor's center the tile's center
            float dist=distance(f_st,point);
            
            // Store the distance to the closest centroid
            // This also compares with our current block's center
            min_dist=min(min_dist,dist);
        }
    }
    
    vec3 color=vec3(min_dist);
    gl_FragColor=vec4(color,1.);
}