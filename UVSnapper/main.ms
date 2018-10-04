/*
Written by Jeffrey Xiaoyue Chen
This script automatically snaps UV islands' vertices together. 
It is helpful when users want to stack/overlap UV islands to save texture space.
*/

Rollout OverlapUVSnapper "OverlapUVSnapper"
(
	button selectTarget "Select Target Island"
	checkbox autoTarget "Auto Target"
	button selectChangeable "Select Changeable Island(s)"
	spinner threshold "Threshold: " range:[0,100,0.1] type:#float 
	button snap "Snap"

	struct vertexInfo (index, position)
	
	local unwrapper =$.Unwrap_UVW
	local changeable, target
	
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
	
	fn collectVertexInfo =
	(
		local collection = vertexInfo()
		collection.index = unwrapper.getSelectedVertices() as Array
		collection.position = for i in 1 to collection.index.count collect 
			unwrapper.getVertexPosition currentTime collection.index[i]
		return collection
	)

	on selectTarget pressed do
	(
		target = collectVertexInfo()
	)
		
	on selectChangeable pressed do
	(
		changeable = collectVertexInfo()
		
		if autoTarget.state == true do
		(
			target = changeable
		)
	)

	on snap pressed do 
	(
		if target != undefined and changeable != undefined do
		(
			snapToTarget()
		)
	)
	
	on autoTarget changed theState do
	(
		selectTarget.enabled = not autoTarget.state
	)	
	
)

createDialog OverlapUVSnapper