macroScript UVSnapper 
/*
Written by Jeffrey Xiaoyue Chen
Email: xiaoyue_chen@outlook.com

This script automatically snaps UV islands' vertices together. 
It is helpful when users want to stack/overlap UV islands to save texture space.
*/
category:"UVW Unwrap Custom" 
buttontext:"Snap UV"
tooltip:"Select Vertices and Submmit"
(
	--struct to store index number and point3 position of a vertex
	struct vertexInfo (index, position)
	local unwrapper
	
	--check if the current modifier is Unwrap_UVW
	fn isModUnwrapUVW =
	(
		classOf (modpanel.getCurrentObject())== Unwrap_UVW
	)
	
	--enable the button if the current modifier is Unwrap_UVW
	on isEnabled return isModUnwrapUVW()
	
	--assgin the modifier to unwrapper
	fn assignUnwrapper = 
	(
		setCommandPanelTaskMode #modify
		unwrapper = modpanel.getCurrentObject()
	)
	
	--conver point3's x and y to a point2
	fn point3ToPoint2 p3 = 
	(
		return [p3.x, p3.y]
	)
	
	--convert so that z(w) value or the origin vertex is not affected
	fn convertDestinPosition originPos destinPos= 
	(
		return [destinPos.x, destinPos.y, originPos.z]
	)
	
	
	--snap origin vertices to destination vertices if closer than threshold
	fn snapToTarget origin destin threshold= 
	(
		for oVertex in origin do
		(
			local destinPos
			for dVertex in destin do
			(
				local dist = distance (point3ToPoint2 oVertex.position) (point3ToPoint2 dVertex.position)
				if dist < threshold do
				(
					destinPos = convertDestinPosition oVertex.position dVertex.position					
				)
			)
			unwrapper.setVertexPosition currentTime oVertex.index destinPos
		)
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

			
	on Execute do
	(
		assignUnwrapper()
			
		Rollout OverlapUVSnapper "Overlap UV Snapper"
		(
			--draw UI
			button selectTarget "Summit Target"
			checkbox autoTarget "Auto Target"
			button selectChangeable "Summit Changeable"
			spinner threshold "Threshold: " range:[0,100,0.01] type:#float 
			button snap "Snap"
			button resetSnap "Reset"
			
			--changeable and target vertices collections
			local changeable, target

			on selectTarget pressed do
			(
				--assgin collected vertex info array to target
				target = collectVertexInfo()
			)
				
			on selectChangeable pressed do
			(
				--assgin collected vertex info array to changeable
				changeable = collectVertexInfo()
				
				--set target to changeable if autoTarget is checked
				if autoTarget.state == true do
				(
					target = changeable
				)
			)

			on snap pressed do 
			(
				--check if target and changeable collections are defined
				if target != undefined and changeable != undefined do
				(
					snapToTarget changeable target threshold.value
				)
			)
			
			on autoTarget changed theState do
			(
				--en/dis able the selectTarget button
				selectTarget.enabled = not autoTarget.state
			)	
			
			on resetSnap pressed do 
			(
				--reset the positions of the vertices in the changeable collection
				resetPosition changeable
			)		
		)
		
		createDialog OverlapUVSnapper
	)
)