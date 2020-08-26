from numpy import sin, cos
from vapory import *

a = -2
b = 2
c = -1.2
d = -1.2
x, y = 0, 0
max_points = 5000000

def func(x, y):
    return sin(a*y) - cos(b*x), sin(c*x) - cos(d*y)

points = [None for i in range(max_points)]
for i in range(max_points):
    sphere = Sphere([x, y, 3], 0.001,
                    Pigment('color', [1-2*x, 0.5, 1-2*y]),
                    Finish('diffuse', 0.7,
                           'ambient', 0,
                           'specular', 0.3,
                           'reflection', 0.8, 'metallic'), 'scale', 2)
    points[i] = sphere
    x, y = func(x, y)

camera = Camera('location', [0, 0, -5], 'look_at', [0, 0, 0])
light1 = LightSource([40, 80, -40], 'color', [1, 1, 1],
                     'area_light', [8, 0, 0], [0, 0, 8], 4, 4,
                     'adaptive', 0, 'jitter', 'circular', 'orient')

light2 = LightSource([0, 20, -20], 'color', [1, 1, 1])
plane = Plane([0, 1, 0], -4, 'hollow', Pigment('color', [1, 1, 1]))

scene = Scene(camera, objects=[light1, light2, plane] + points)
scene.render('pdj.png', width=2560, height=1600, antialiasing=0.001)
