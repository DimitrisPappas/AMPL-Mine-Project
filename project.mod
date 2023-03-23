param m;	# number of mines
param t;	# number of years (time)

set Mines;	# Ορυχεία
set Years;	# Έτη

# Parameters
param mining_limit {Mines} >=0;				# ¶νω όριο εξόρυξης για κάθε ορυχείο
param contributions {Mines} >=0;			# Εισφορές κάθε ορυχείου
param quality {Mines} >=0;					# Δείκτης Ποιότητας για κάθε ορυχείο
param mixture_quality {Years} >=0;			# Δείκτης Ποιότητας Μίγματος για κάθε έτος

# Decision Variables
var x {i in Mines, j in Years} >=0;	# Ποσότητα εξόρυξης του ορυχείου i το j έτος
var y {i in Mines, j in Years}	binary;		# Το ορυχείο i λειτουργεί/δεν λειτουργεί το j έτος
var z {i in Mines, j in Years}	binary;		# Το ορυχείο i είναι ανοιχτό/κλειστό (μόνιμα) το j έτος

# Objective Function
maximize profit:
	sum {j in Years} 1/(1.1)^(j-1) * (sum{i in Mines} (10*x[i,j] - contributions[i] * z[i,j]));

# Restrictions	
s.t. Mining_Limit {i in Mines, j in Years}:
	x[i,j] <= mining_limit[i] * y[i,j];
	
s.t. Working_Mines_Each_Year {j in Years}:
	sum {i in Mines} y[i,j] <= 3;
	
s.t. Mixture_Quality_Each_Year {j in Years}:
	sum {i in Mines} (quality[i] * x[i,j]) = mixture_quality[j] * sum {k in Mines}  x[k,j];
	
s.t. Closed1 {i in Mines, j in Years}:
	z[i,j] >= y[i,j];

s.t. Closed2 {i in Mines, j in 1..t-1}:
	z[i,j] >= z[i,j+1];
	