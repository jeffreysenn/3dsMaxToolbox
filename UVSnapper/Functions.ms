--This script contains all the functions for OverlapUVSnapper's main script 
	
	--struct to store index number and point3 position of vertices collections
	struct vertexInfo (index, position)
	
	global unwrapper = $.Unwrap_UVW
	
	--snap origin vertices to destination vertices if closer than threshold
	fn snapToTarget origin destin threshold= 
	(
		for i in 1 to origin.index.count do
		(
			for j in 1 to destin.index.count do
			(
				local dist = distance origin.position[i] destin.position[j]
				if dist < threshold then
				(
					unwrapper.setVertexPosition currentTime origin.index[i] destin.position[j]
				)
			)
		)
	)
	
	--collect index number and point3 position of the selected vertices
	fn collectVertexInfo =
	(
		local collection = vertexInfo()
		--add each vertex's index number to the index array
		collection.index = unwrapper.getSelectedVertices() as Array
		--loop through the index array, and add each vertex's point3 position to the position array
		collection.position = for i in 1 to collection.index.count collect 
			unwrapper.getVertexPosition currentTime collection.index[i]
		return collection
	)
	
	--reset the snapped vertices to original position
	fn resetPosition collection= 
	(
		for i in 1 to collection.index.count do 
		(
			unwrapper.setVertexPosition currentTime collection.index[i] collection.position[i]
		)
	)