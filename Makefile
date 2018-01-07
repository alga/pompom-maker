all: img stl

img:
	openscad --viewall --colorscheme=Metallic -o assy.png assy.scad
	openscad --viewall --colorscheme=Metallic -o ring.png ring.scad
	openscad --viewall --colorscheme=Metallic -o quarter.png quarter.scad

stl:
	openscad -o ring.stl ring.scad
	openscad -o quarter.stl quarter.scad

clean:
	rm *.png *.stl
