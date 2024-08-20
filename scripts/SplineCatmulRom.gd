class_name CatmulRomSpline


static func make_spline(p0, p1, p2, p3, resolution, alpha):
	
	var tj = func tj(ti: float, pi: Vector2, pj: Vector2):
		return pow(pj.distance_to(pi), alpha) + ti
	
	var t0 = 0.0
	var t1 = tj.call(t0, p0, p1)
	var t2 = tj.call(t1, p1, p2)
	var t3 = tj.call(t2, p2, p3)
	
	var step = (t2 - t1) / (resolution - 1)
	var curve: Array[Vector2]
	
	for i in range(resolution - 1):
		var t = t1 + i * step
		
		var a1 = (t1 - t) / (t1 - t0) * p0 + (t - t0) / (t1 - t0) * p1
		var a2 = (t2 - t) / (t2 - t1) * p1 + (t - t1) / (t2 - t1) * p2
		var a3 = (t3 - t) / (t3 - t2) * p2 + (t - t2) / (t3 - t2) * p3
		
		var b1 = (t2 - t) / (t2 - t0) * a1 + (t - t0) / (t2 - t0) * a2
		var b2 = (t3 - t) / (t3 - t1) * a2 + (t - t1) / (t3 - t1) * a3
		
		var c = (t2 - t) / (t2 - t1) * b1 + (t - t1) / (t2 - t1) * b2
		curve.append(c)
	return curve
