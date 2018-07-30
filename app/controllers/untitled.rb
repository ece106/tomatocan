profilepic SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'
      OR (profilepicurl SIMILAR TO 'http%' AND 
      profilepicurl SIMILAR TO '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)%')


      profilepic LIKE '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)'
       OR (profilepicurl LIKE 'http%' AND 
       profilepicurl LIKE '%(jpg|gif|tif|png|jpeg|GIF|JPG|JPEG|TIF|PNG)%')

        (profilepic LIKE '%jpg%' OR profilepic LIKE '%gif%' OR profilepic LIKE '%tif%' OR profilepic LIKE '%png%' OR profilepic LIKE '%jpeg%' OR profilepic LIKE '%GIF%' OR profilepic LIKE '%JPG%' OR profilepic LIKE '%JPEG%' OR profilepic LIKE '%TIF%' OR profilepic LIKE '%PNG%')
       OR (profilepicurl LIKE 'http%' AND 
       profilepic LIKE '%jpg%' OR profilepic LIKE '%gif%' OR profilepic LIKE '%tif%' OR profilepic LIKE '%png%' OR profilepic LIKE '%jpeg%' OR profilepic LIKE '%GIF%' OR profilepic LIKE '%JPG%' OR profilepic LIKE '%JPEG%' OR profilepic LIKE '%TIF%' OR profilepic LIKE '%PNG%')




       userswithpic = User.where( " (profilepic LIKE '%jpg' OR profilepic LIKE '%gif' OR profilepic LIKE '%tif' OR profilepic LIKE '%png' OR profilepic LIKE '%jpeg' OR profilepic LIKE '%GIF' OR profilepic LIKE '%JPG' OR profilepic LIKE '%JPEG' OR profilepic LIKE '%TIF' OR profilepic LIKE '%PNG')
       OR (profilepicurl LIKE 'http%' AND 
       profilepic LIKE '%jpg' OR profilepic LIKE '%gif' OR profilepic LIKE '%tif' OR profilepic LIKE '%png' OR profilepic LIKE '%jpeg' OR profilepic LIKE '%GIF' OR profilepic LIKE '%JPG' OR profilepic LIKE '%JPEG' OR profilepic LIKE '%TIF' OR profilepic LIKE '%PNG')")