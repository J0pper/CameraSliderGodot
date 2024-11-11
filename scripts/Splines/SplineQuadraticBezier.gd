class_name QuadraticBezierSpline


static func make_spline(p0, p1, p2, time):
	return floor((1 - time) ** 2 * p0 + 2 * (1 - time) * time * p1 + time ** 2 * p2)
