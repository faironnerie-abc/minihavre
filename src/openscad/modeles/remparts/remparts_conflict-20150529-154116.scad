use <extrusion.scad>;

//p0 = [[0.000000, 297.000000],[2.600000, 291.000000],[2.400000, 290.800000],[2.400000, 290.600000],[2.600000, 290.400000],[2.600000, 282.400000],[4.000000, 282.400000],[4.000000, 283.200000],[8.800000, 283.200000],[8.800000, 291.400000],[10.200000, 297.000000]];
p0 = [[0.000000, 0.000000],[2.600000, -6.000000],[2.400000, -6.200000],[2.400000, -6.400000],[2.600000, -6.600000],[2.600000, -14.600000],[4.000000, -14.600000],[4.000000, -13.800000],[8.800000, -13.800000],[8.800000, -5.600000],[10.200000, -0.000000]];
//p1 = transform(rotation([90, 0, 0]), p0);

module base() {
	//profil();

	rotate([-90,0,0])
	skin([transform(translation([0,0,0]), p0),
		  transform(translation([0,0,10]), p0),
		  transform(translation([-2,0,20]), p0),
		  transform(translation([-10,0,40]), p0)
		 ]);

	// skin([
	// 	transform(translation([0, 0,0]), profil()),
	// 	transform(translation([0,10,0]), profil())
	// ]);
	// fn=32;

	// skin([
	// 	transform(translation([0,0,0]), rounded_rectangle_profile([2,4],fn=fn,r=.5)),
	// 	transform(translation([0,0,2]), rounded_rectangle_profile([2,4],fn=fn,r=.5))
	// ]);


}

base();