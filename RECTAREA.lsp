(vl-load-com)

;========================================================
; RECTAREA
; Calculate net area and total perimeter from rectangles
;
; Workflow:
; 1- Select multiple closed rectangles
; 2- Largest rectangle = main area
; 3- Smaller rectangles = holes/openings
; 4- Net Area = Outer Area - Inner Areas
; 5- Total Perimeter = Outer Perimeter + Inner Perimeters
; 6- Create AutoCAD table with results
;========================================================


(defun c:RECTAREA
       (/ ss i ent obj area peri
          data outerArea innerArea
          outerPeri totalPeri
          netArea finalPeri
          pt doc ms tbl row)


  ;------------------------------------------
  ; Select all closed polylines (rectangles)
  ;------------------------------------------

  (setq ss
    (ssget '((0 . "LWPOLYLINE"))))


  (if ss
    (progn


      ; Store object information
      (setq data '())


      ; Initialize values

      (setq outerArea 0)
      (setq innerArea 0)

      (setq totalPeri 0)



      ;------------------------------------------
      ; Read every selected object
      ; Save:
      ;   Area
      ;   Perimeter
      ;------------------------------------------

      (setq i 0)


      (repeat (sslength ss)


        ; Get entity

        (setq ent
          (ssname ss i))


        ; Convert AutoCAD object

        (setq obj
          (vlax-ename->vla-object ent))



        ; Get object area

        (setq area
          (vla-get-Area obj))



        ; Get object perimeter

        (setq peri
          (vla-get-Length obj))



        ; Save data

        (setq data
          (append data
            (list
              (list area peri)
            )
          )
        )



        (setq i (+ i 1))

      )




      ;------------------------------------------
      ; Find the biggest rectangle
      ; It will be considered as outer boundary
      ;------------------------------------------

      (setq outerArea
        (apply 'max
          (mapcar 'car data)
        )
      )





      ;------------------------------------------
      ; Separate outer rectangle
      ; and inner rectangles
      ;------------------------------------------

      (foreach x data


        ; If area equals biggest area
        ; this is the main rectangle

        (if (= (car x) outerArea)


          ; Save outer perimeter

          (setq outerPeri
            (cadr x))



          ; Otherwise it is a hole

          (progn


            ; Add inner areas

            (setq innerArea
              (+ innerArea
                 (car x)))



            ; Add inner perimeters

            (setq totalPeri
              (+ totalPeri
                 (cadr x)))

          )

        )

      )





      ;------------------------------------------
      ; Final calculations
      ;------------------------------------------


      ; Remove holes from main area

      (setq netArea
        (- outerArea innerArea))



      ; Add all boundaries

      (setq finalPeri
        (+ outerPeri totalPeri))





      ;------------------------------------------
      ; Ask user where to place table
      ;------------------------------------------

      (setq pt
        (getpoint
          "\nPick table position: "))





      ; Get current AutoCAD document

      (setq doc
        (vla-get-ActiveDocument
          (vlax-get-acad-object)))



      ; Get model space

      (setq ms
        (vla-get-ModelSpace doc))





      ;------------------------------------------
      ; Create AutoCAD table
      ;------------------------------------------

      (setq tbl
        (vla-AddTable
          ms
          (vlax-3d-point pt)

          ; Rows:
          ; objects + header + result rows

          (+ (length data) 3)

          ; Columns

          3

          ; Row height

          8

          ; Column width

          35
        )
      )





      ;------------------------------------------
      ; Table Header
      ;------------------------------------------

      (vla-SetText tbl 0 0 "Object")

      (vla-SetText tbl 0 1 "Area")

      (vla-SetText tbl 0 2 "Perimeter")





      ;------------------------------------------
      ; Fill object data
      ;------------------------------------------

      (setq row 1)


      (foreach x data


        (vla-SetText tbl row 0

          (strcat
            "Rectangle "
            (itoa row)
          )
        )



        (vla-SetText tbl row 1

          (rtos
            (car x)
            2
            2)
        )



        (vla-SetText tbl row 2

          (rtos
            (cadr x)
            2
            2)
        )


        (setq row (+ row 1))

      )





      ;------------------------------------------
      ; Add final result rows
      ;------------------------------------------


      ; Net area

      (vla-SetText tbl row 0
        "NET AREA")


      (vla-SetText tbl row 1
        (rtos netArea 2 2))



      (setq row (+ row 1))



      ; Total perimeter

      (vla-SetText tbl row 0
        "TOTAL PERIMETER")


      (vla-SetText tbl row 2
        (rtos finalPeri 2 2))





      (princ
        "\nCalculation completed successfully.")

    )

  )


  (princ)

)
