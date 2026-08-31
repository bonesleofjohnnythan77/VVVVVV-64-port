const Collision spike_wall_collision[] = {
	COL_INIT(),
	COL_VERTEX_INIT(12),
	COL_VERTEX(368, 0, -200),
	COL_VERTEX(101, 0, 200),
	COL_VERTEX(368, 0, 200),
	COL_VERTEX(320, 1600, -200),
	COL_VERTEX(101, 1600, 200),
	COL_VERTEX(320, 1600, 200),
	COL_VERTEX(101, 0, -200),
	COL_VERTEX(101, 1600, -200),
	COL_VERTEX(-100, 0, 200),
	COL_VERTEX(-100, 1600, 200),
	COL_VERTEX(-100, 0, -200),
	COL_VERTEX(-100, 1600, -200),
	COL_TRI_INIT(1, 12),
	COL_TRI(0, 1, 2),
	COL_TRI(3, 4, 5),
	COL_TRI(3, 2, 0),
	COL_TRI(3, 6, 7),
	COL_TRI(1, 5, 4),
	// COL_TRI(6, 8, 1),   // box seam
	// COL_TRI(7, 9, 4),   // box seam
	// COL_TRI(10, 9, 8),  // box face
	// COL_TRI(6, 11, 7),  // box face
	// COL_TRI(1, 9, 8),   // box seam
	COL_TRI(7, 1, 6),
	COL_TRI(0, 6, 1),
	COL_TRI(3, 7, 4),
	COL_TRI(3, 5, 2),
	COL_TRI(3, 0, 6),
	COL_TRI(1, 2, 5),
	// COL_TRI(6, 10, 8),  // box face
	// COL_TRI(7, 11, 9),  // box face
	// COL_TRI(10, 11, 9), // box face
	// COL_TRI(6, 10, 11), // box face
	// COL_TRI(1, 4, 9),   // box seam
	COL_TRI(7, 4, 1),
	COL_TRI_STOP(),
	COL_END(),
};
