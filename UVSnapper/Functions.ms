--This script contains all the functions for OverlapUVSnapper's main script 
	
	--struct to store index number and point3 position of a vertex
	struct vertexInfo (index, position)
	
	--assgin the modifier to unwrapper
	setCommandPanelTaskMode #modify
	global unwrapper = modpanel.getCurrentObject()
	
	

	--snap origin vertices to destination vertices if closer than threshold
	fn snapToTarget origin destin threshold= 
	(
		for oVertex in origin do
		(
			local destinPos
			for dVertex in destin do
			(
				local dist = distance (point3ToPoint2 oVertex.position) (point3ToPoint2 dVertex.position)
				--print("Between " + dist as string)
				if dist < threshold do
				(
					destinPos = convertDestinPosition oVertex.position dVertex.position					
				)
			)
			unwrapper.setVertexPosition currentTime oVertex.index destinPos
		)
	)
	
	fn point3ToPoint2 p3 = 
	(
		return [p3.x, p3.y]
	)
	
	fn convertDestinPosition originPos destinPos= 
	(
		return [destinPos.x, destinPos.y, originPos.z]
	)
	
	
	--collect index number and point3 position of the selected vertices and make them into an array
	fn collectVertexInfo =
	(
		local indexCollection = unwrapper.getSelectedVertices() as Array
		local collection = for index in indexCollection collect 
			vertexInfo index:index position:(unwrapper.getVertexPosition currentTime index)
		
		return collection
	)
	
	--reset the snapped vertices to original position
	fn resetPosition collection= 
	(
		for vertex in collection do 
		(
			unwrapper.setVertexPosition currentTime vertex.index vertex.position
		)
	)