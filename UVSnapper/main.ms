/*
Written by Jeffrey Xiaoyue Chen
This script automatically snaps UV islands' vertices together. 
It is helpful when users want to stack/overlap UV islands to save texture space.
*/

fileIn "Functions.ms"

Rollout OverlapUVSnapper "Overlap UV Snapper"
(
	--draw UI
	button selectTarget "Select Target Island"
	checkbox autoTarget "Auto Target"
	button selectChangeable "Select Changeable Island(s)"
	spinner threshold "Threshold: " range:[0,100,0.1] type:#float 
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