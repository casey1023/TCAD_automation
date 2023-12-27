(define Lsub 20)
(define L 10)
(define Hsub 5)
(define Lsd (* (- Lsub L) 0.5))
(define Hsd 1)
(define tox 10e-3)
(define p_doping -1e16)
(define n_doping 1e20)
(define path_123 "your_path/MOSFET")

	(sdegeo:create-rectangle (position (* Lsub -0.5) 0 0) (position (* Lsub 0.5) Hsub 0) "Silicon" "Substrate" )
	(sdegeo:create-rectangle (position (* L -0.5) 0 0) (position (* L 0.5) (* tox -1) 0) "SiO2" "Oxide" )

	(sdedr:define-refeval-window "Ref_Source" "Rectangle" (position (* Lsub -0.5) 0 0) (position (+ (* Lsub -0.5) Lsd) Hsd 0))
	(sdedr:define-refeval-window "Ref_Drain" "Rectangle" (position (- (* Lsub 0.5) Lsd) 0 0) (position (* Lsub 0.5) Hsd 0))
	(sdedr:define-refeval-window "Ref_Channel" "Rectangle" (position (* L -0.5) 0 0) (position (* L 0.5) 0.01 0))
	(sdedr:define-refeval-window "Ref_BelowChannel" "Rectangle" (position (* L -0.5) 0.01 0) (position (* L 0.5) Hsd 0))
	(sdedr:define-refeval-window "Ref_Body" "Rectangle" (position (* Lsub -0.5) Hsd 0) (position (* Lsub 0.5) Hsub 0))
	(sdedr:define-refeval-window "Ref_Oxide" "Rectangle" (position (* L -0.5) 0 0) (position (* L 0.5) (* tox -1) 0))	



	(sdedr:define-constant-profile "n1e20" "DopingConcentration" n_doping)
	(sdedr:define-constant-profile-placement "Place_Source" "n1e20" "Ref_Source")
	(sdedr:define-constant-profile-placement "Place_Drain" "n1e20" "Ref_Drain")

	(sdedr:define-constant-profile "p3e17" "DopingConcentration" p_doping)
	(sdedr:define-constant-profile-region "Place_Substrate" "p3e17" "Substrate")


	(sdegeo:define-contact-set "Gate" 4  (color:rgb 1 0 0 ) "##" )
	(sdegeo:set-current-contact-set "Gate")
	(sdegeo:define-2d-contact (list (car (find-edge-id (position 0 (* tox -1) 0)))) "Gate")
	(render:rebuild)	


	(sdegeo:define-contact-set "Source" 4  (color:rgb 0 1 0 ) "##" )
	(sdegeo:set-current-contact-set "Source")
	(sdegeo:define-2d-contact (list (car (find-edge-id (position (* (- Lsub Lsd) -0.5) 0 0)))) "Source")
	(render:rebuild)	


	(sdegeo:define-contact-set "Drain" 4  (color:rgb 0 0 1 ) "##" )
	(sdegeo:set-current-contact-set "Drain")
	(sdegeo:define-2d-contact (list (car (find-edge-id (position (* (- Lsub Lsd) 0.5) 0 0)))) "Drain")
	(render:rebuild)	


	(sdegeo:define-contact-set "Body" 4  (color:rgb 1 1 0 ) "##" )
	(sdegeo:set-current-contact-set "Body")
	(sdegeo:define-2d-contact (list (car (find-edge-id (position 0 Hsub 0)))) "Body")
	(render:rebuild)	


	(sdedr:define-refinement-size "Def_Body" 
		1    1  0
		1    1  0 )
	(sdedr:define-refinement-placement "Place_Body" "Def_Body" (list "window" "Ref_Body"))


	
	(sdedr:define-refinement-size "Def_Channel" 
		0.01   0.005   0
		0.01   0.005   0 )
	(sdedr:define-refinement-placement "Place_Channel" "Def_Channel" (list "window" "Ref_Channel" ))



	(sdedr:define-refinement-size "Def_BelowChannel" 
		0.1   0.1   0
		0.1   0.1   0 )
	(sdedr:define-refinement-placement "Place_BelowChannel" "Def_BelowChannel" (list "window" "Ref_BelowChannel" ))



	
	(sdedr:define-refinement-size "Def_SD" 
		0.5   0.5   0
		0.5   0.5   0 )
	(sdedr:define-refinement-placement "Place_Source" "Def_SD" (list "window" "Ref_Source" ))
	(sdedr:define-refinement-placement "Place_Drain" "Def_SD" (list "window" "Ref_Drain" ))



	(sdedr:define-refinement-size "Def_Oxide" 
		0.02   0.01   0
		0.02   0.01   0 )
	(sdedr:define-refinement-placement "Place_Oxide" "Def_Channel" (list "window" "Ref_Oxide"))



	(sde:save-model path_123)
	(sde:set-meshing-command "snmesh")
	(sde:build-mesh "" path_123)
