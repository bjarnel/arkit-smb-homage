
uniform float deformFactor;
uniform float scaleUpFactor;
uniform int allowNegative;

float factor = sin(u_time + scaleUpFactor * _geometry.position.x + scaleUpFactor * _geometry.position.y - _geometry.position.z * scaleUpFactor) * deformFactor;

if(allowNegative == 0) {
factor = (factor + 1.0) * 0.5;
}

_geometry.position.x += _geometry.normal.x * factor;
_geometry.position.y += _geometry.normal.y * factor;
_geometry.position.z += _geometry.normal.z * factor;
