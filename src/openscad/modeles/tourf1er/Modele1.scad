// Unités : mm, échelle 1/1000

rayon = 3.5;			// Rayon de la tour.
merlon_n = 13.;			// 13 créneaux / merlons.
merlon_l = 2./3.;		// Importance d'un merlon.
creneau_l = 1./3.; 		// Importance d'un créneau.
bossage_minh = 2.1;		// Début en hauteur du bossage du mur.
bossage_maxh = 4.8;		// Fin du bossage du mur.
bossage_par_line = 40;	// Nombre de pointes de bossage par ligne.
lignes_de_bossage = 10; // Nombre de lignes de bossage (en tout, donc /2 par niveau).

/** Profil de la tour, chargé à partir d'Inkscape. */
module profil() {
	import("profil.dxf");
}

/** Extrusion radiale du profil de la tour et bossage. */
module base() {
	union() {
		rotate_extrude(convexity=10, $fn=100) {  profil(); }
		bossage(rayon, lignes_de_bossage, bossage_par_line);
	}
}

/** Un espace entre chaque merlon. */
module creneau() {
	ensemble = 360 / merlon_n;			// Angle d'un ensemble merlon+creneau.
	merlon   = creneau_l * ensemble;	// Angle d'un merlon.

	polyhedron(points=[[0, 0, 1], [10*cos(merlon), 0, 0], [10*cos(merlon), 10*sin(merlon), 0], 
		                          [10*cos(merlon), 0, 2], [10*cos(merlon), 10*sin(merlon), 2]],
		       faces=[[0, 1, 2],		// bas
		              [0, 3, 1],		// gauche
		              [0, 2, 4],		// droit
		              [0, 4, 3],		// haut
		              [3, 4, 1],		// fond 1
		              [1, 4, 2]			// fond 2
		             ]);
}

/** L'ensemble des créneaux (futurs creux) de la tour. */
module creneaux() {
	ensemble = 360 /  merlon_n;
	for(i = [0:ensemble:360]) {
		rotate([0,0,i]) creneau();
	}
}

/** Un bossage en point de diamant.
  * @rayon où positionner la bosse sur la surface de la tour.
  * @elevation où positionner la bosse sur la hauteur de la tour.
  * @echelle échelle de la bosse. */
module bossage_diamant(rayon, elevation, echelle = 0.15) {
	translate([rayon, 0, elevation]) scale([echelle,echelle,echelle]) rotate([0,90,0]) linear_extrude(height=0.5, scale=0.2) square([1, 1], center=true);
}

/** Une ligne de bossage sur le pourtour de la tour.
  * @rayon où positionner les embossages sur la surface de la tour.
  * @elevation hauteur de la ligne de bossage.
  * @compte_par_ligne nombre de bosse par ligne.
  * @decalage rotation en degré de la ligne comlète. */
module ligne_bossage(rayon, elevation, compte_par_ligne, decalage) {
	angle = 360./compte_par_ligne;
	for(i=[0:angle:360]) {
		rotate([0,0,i+decalage]) bossage_diamant(rayon, elevation);
	}
}

/** L'ensemble du bossage des murs.
  * @rayon où positionner les embossages sur la surface de la tour.
  * @compte nombre de lignes de bossage.
  * @compte_par_line nombre de bosses par ligne.
  * @decalage rotation en degrés, décalage appliqué à chaque ligne. */
module bossage(rayon, compte, compte_par_ligne, decalage=3) {
	step  = (bossage_maxh-bossage_minh) / (compte-1);
	decal = [ for(d=[0:decalage:(compte*decalage)]) d ];
	haut  = [ for(h=[bossage_minh:step:bossage_maxh]) h ];

	for(i=[0:1:compte-1]) {
		if(i < (compte/2))
		     ligne_bossage(rayon+0.03, haut[i], compte_par_ligne, decal[i]);
		else ligne_bossage(rayon, haut[i]+0.1, compte_par_ligne, decal[i]);
	}	
}

/** La tour complète. */
module tour() {
	difference() {
		base();
		translate([0, 0, 4.15]) creneaux();		
	}
}

tour();
