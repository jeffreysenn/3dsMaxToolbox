macroScript SelEdgesByAngle 
    category:"PolyMeshTools" 
    buttontext:"Edges By Angle"
    tooltip:"Select Edges By Angle"
   (
   	local theThreshold = 30
   	local include_open_edges = false	
   	local auto_preview_selection = true
   	fn filter_function =
   	(
   		theObj = modPanel.getCurrentObject()
 	subObjectLevel == 2 and selection.count == 1 and (classof theObj == Editable_Poly or (classof theObj == Edit_Poly and theObj.enabled and theObj.enabledInViews))
   	)
   	on isEnabled return filter_function()
   	on isVisible return filter_function()
   	
   	fn perform_selection =
   	(
   		selEdges = #{}
   		theObj = $
   		
   		eCount = polyOp.getNumEdges theObj
   		for e = 1 to eCount do
   		(
   			theFaces = (polyOp.getEdgeFaces theObj e) as array
   			if theFaces.count == 2 then
   			(
 			 theAngle = acos(dot (polyOp.getFaceNormal theObj theFaces[1]) (polyOp.getFaceNormal theObj theFaces[2])) 
 				if theAngle >= theThreshold do selEdges[e] = true
   			)	
   			else 
 				if include_open_edges do selEdges[e] = true
   		)
   		case classof (modPanel.getCurrentObject()) of
   		(
 			Editable_Poly: polyOp.setEdgeSelection theObj selEdges 
  		    Edit_Poly: (modPanel.getCurrentObject()).SetSelection #Edge &selEdges 
   		)	
   		redrawViews()	
   	)
   	
   	on Execute do
   	(
   		rollout SelEdgesByAngle_Rollout "Select Edges By Angle"
   		(
 			checkbox include_open "Include Open Edges" checked:include_open_edges
 		 spinner threshold_value "Angle Threshold" range:[0,180,theThreshold] type:#float fieldwidth:60
 		 checkbutton preview_selection "Preview" width:85 across:2 align:#left checked:auto_preview_selection
   			button select_now "Update" width:85 align:#right
   			on threshold_value changed val do 
   			(
   				theThreshold = val
 			if preview_selection.checked and filter_function() do perform_selection()
   			)	
   			on include_open changed state do 
   			(
   				include_open_edges = state
 				if filter_function() do perform_selection()
   			)	
 			on preview_selection changed state do auto_preview_selection = state
 			on select_now pressed do if filter_function() do perform_selection()
   		)
   		createDialog SelEdgesByAngle_Rollout 200 70 
   	)
   )