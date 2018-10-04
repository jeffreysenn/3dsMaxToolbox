/*
Written by Jeffrey Xiaoyue Chen
This script automatically snaps UV islands' vertices together. 
It is helpful when users want to stack/overlap UV islands to save texture space.
*/

Rollout OverlapUVSnapper "OverlapUVSnapper"
(
	button selectTarget "Select Target Island"
	button selectChangeable "Select Changeable Island(s)"
	spinner threshold "Threshold: " range:[0,100,0.1] type:#float 
	button snap "Snap"

	local unwrapper =$.Unwrap_UVW
	local target, changeable
	local targetPos, changeablePos

	-- Store the target 
	on selectTarget pressed do
	(
		target = unwrapper.getSelectedVertices() as Array
		targetPos = for i in 1 to target.count collect 
			Unwrapper.getVertexPosition currentTime target[i]
	)
		
	on selectChangeable pressed do
	(
		changeable = unwrapper.getSelectedVertices() as Array
		changeablePos = for i in 1 to changeable.count collect 
			Unwrapper.getVertexPosition currentTime changeable[i]
	)

	on snap pressed do 
	(
		for i in 1 to changeable.count do
		(
			for j in 1 to target.count do
			(
				local dis = distance changeablePos[i] targetPos[j]
				if dis < threshold.value then
				(
					unwrapper.setVertexPosition currentTime changeable[i] targetPos[j]
				)
			)
		)
	)

)

createDialog OverlapUVSnapper