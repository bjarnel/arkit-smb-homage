
// how much it deforms (for hozizontal plane: wave height)
uniform float geomIntensity;

// proves more "bubbles" over same area, but not actually more frequent as a whole?
uniform float freq;

// faster moving "waves"?
uniform float power;

// affects wave height (this * geomIntensity)
uniform float factor;

vec3 p = _geometry.position.xyz;
float disp = factor * geomIntensity * pow(0.5 + 0.5 * cos(freq * p.x + 1.5 * u_time) * sin(freq * p.y + 2.5 * u_time) * sin(freq * p.z + 1.0 * u_time), power);
_geometry.position.xyz += _geometry.normal * disp;



vec3 e = vec3(0.1, 0.0, 0.0);
vec3 n = _geometry.normal;



float x1 = pow(0.5 + 0.5 * cos(freq * (p + e.xyy).x + 1.5 * u_time) * sin(freq * (p + e.xyy).y + 2.5 * u_time) * sin(freq * (p + e.xyy).z + 1.0 * u_time), power);
float x2 = pow(0.5 + 0.5 * cos(freq * (p - e.xyy).x + 1.5 * u_time) * sin(freq * (p - e.xyy).y + 2.5 * u_time) * sin(freq * (p - e.xyy).z + 1.0 * u_time), power);

float y1 = pow(0.5 + 0.5 * cos(freq * (p + e.yxy).x + 1.5 * u_time) * sin(freq * (p + e.yxy).y + 2.5 * u_time) * sin(freq * (p + e.yxy).z + 1.0 * u_time), power);
float y2 = pow(0.5 + 0.5 * cos(freq * (p - e.yxy).x + 1.5 * u_time) * sin(freq * (p - e.yxy).y + 2.5 * u_time) * sin(freq * (p - e.yxy).z + 1.0 * u_time), power);

float z1 = pow(0.5 + 0.5 * cos(freq * (p + e.yyx).x + 1.5 * u_time) * sin(freq * (p + e.yyx).y + 2.5 * u_time) * sin(freq * (p + e.yyx).z + 1.0 * u_time), power);
float z2 = pow(0.5 + 0.5 * cos(freq * (p - e.yyx).x + 1.5 * u_time) * sin(freq * (p - e.yyx).y + 2.5 * u_time) * sin(freq * (p - e.yyx).z + 1.0 * u_time), power);

_geometry.normal.xyz = normalize(n - geomIntensity * vec3(x1 - x2, y1 - y2, z1 - z2));


// adapted from: https://github.com/pk-nb/scenekit-glshaders/blob/master/CustomShaders/sm_geom.shader
