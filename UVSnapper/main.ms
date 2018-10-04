/*
Written by Jeffrey Xiaoyue Chen
This script automatically snaps UV islands' vertices together. 
It is helpful when users want to stack/overlap UV islands to save texture space.
*/

Rollout OverlapUVSnapper "Overlap UV Snapper"
(
	--draw UI
	button selectTarget "Select Target Island"
	checkbox autoTarget "Auto Target"
	button selectChangeable "Select Changeable Island(s)"
	spinner threshold "Threshold: " range:[0,100,0.1] type:#float 
	button snap "Snap"
	button resetSnap "Reset"

	--struct to store index number and point3 position of vertices collections
	struct vertexInfo (index, position)
	
	local unwrapper =$.Unwrap_UVW
	--changeable and target vertices collections
	local changeable, target
	
	--snap changeable vertices to target vertices if close enough
	fn snapToTarget= 
	(
		for i in 1 to changeable.index.count do
		(
			for j in 1 to target.index.count do
			(
				local dis = distance changeable.position[i] target.position[j]
				if dis < threshold.value then
				(
					unwrapper.setVertexPosition currentTime changeable.index[i] target.position[j]
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
	fn resetPosition = 
	(
		for indexNum in changeable.index do 
		(
			unwrapper.setVertexPosition currentTime indexNum changeable.position[indexNum]
		)
	)

	on selectTarget pressed do
	(
		--feed target collection with vertex info
		target = collectVertexInfo()
	)
		
	on selectChangeable pressed do
	(
		--feed changeable collection with vertex info
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
			snapToTarget()
		)
	)
	
	on autoTarget changed theState do
	(
		--en/dis able the selectTarget button
		selectTarget.enabled = not autoTarget.state
	)	
	
	on resetSnap pressed do 
	(
		resetPosition()
	)
	
)

createDialog OverlapUVSnapper