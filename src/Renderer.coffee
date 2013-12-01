#The renderer class provides a drawing API that simplifies many common drawing operations.
#Many of the methods have a similar signature. The first two parameters are often x, y coordinates and the following parameters are specific to the function. This class can be used independantly, but it is intended to be extended.   

define ['utils'], () ->
    class Renderer
        constructor : (@ctx, @id) ->
            @frame = 0
            @width = 0
            @height = 0
            @static = false
            @looping = false
            @bg = "#CCCCCC"

            # The current x coordinate of the mouse
            @mouseX = 0 
            # The current y coordinate of the mouse
            @mouseY = 0 
            # boolean indicating the mouse is down
            @mouseIsDown = false 
            # boolean indicating the is over this Renderer
            @mouseIsOver = false 
            #boolean indicating that the mouse is dragging
            @mouseIsDragging = false 

        # Set the opacity of all subsequent draw commands
        alpha : (a) =>
            @ctx.globalAlpha = a 

        # Draws and arc
        arc : (x, y, radius, start_angle, end_angle, solid = true) =>
            @ctx.beginPath()
            @ctx.arc x, y, radius, start_angle, end_angle
            if solid then @ctx.fill() else @ctx.stroke()
            @ctx.closePath()

        # Draws a single circle
        circle : (x, y, radius, solid = true) =>
            @ctx.beginPath()
            @ctx.arc x, y, radius, 0, Math.TWO_PI, false
            if solid then @ctx.fill() else @ctx.stroke()
            @ctx.closePath()

        # Draws circles at specified points
        circles : (point_list, radius, solid = true) =>
            if point_list.length is 0 then return
            @circle p[0], p[1], radius, solid for p in point_list

        # Clears the drawing context and redraws the background color
        # This method is called by the player every frame before the render method is called
        clear : =>
            @ctx.save()
            @ctx.globalAlpha = 1
            @ctx.clearRect 0, 0, @width, @height 
            @color @bg
            @rectangle 0, 0, @width, @height
            @ctx.restore()
            
        # Sets the color of both fill and stroke style for all subsequent draw commands 
        # Color values can be supplied in the following formats
        # ``` 
        # @color rgb(255, 0, 0)
        # @color #ff0000
        # @color "red"
        # ```
        color : (color) =>
            @ctx.fillStyle = @ctx.strokeStyle = color

        # Sets the fonstyle
        # ```
        # @font "bold 80pt Baskerville"
        # @font "normal 100px Helvetica"
        # ```
        font : (style) =>
            @ctx.font = style

        # Draws a grid
        grid : (x, y, rows, columns, width, height) =>
            row_height = height / rows
            col_width = width / columns

            for i in [0..rows] by 1
                ypos = (Math.round y + i * row_height) + .5
                @line x, ypos, x + width, ypos

            for i in [0..columns] by 1
                xpos = (Math.round x + i * col_width) + .5
                @line xpos, y, xpos, y + height

        # Draws a line betwen two points
        line : (x1, y1, x2, y2) =>
            @ctx.beginPath()
            @ctx.moveTo x1, y1
            @ctx.lineTo x2, y2
            @ctx.stroke()
            @ctx.closePath()

        # Sets the linestyle for all subsequent draw commands
        lineStyle : (line_width = 1.0, joint_style = "round", cap_style = "round") =>
            @ctx.lineWidth = line_width
            @ctx.lineJoin = joint_style
            @ctx.lineCap = cap_style

        # Draws a series of lines that define shape
        # Lines can be optionally closed and and left un-filled to draw a series of connected lines
        # ```
        # #Draw closed and filled shape
        # @shape [[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]]
        #
        # #Draw connected line segments only
        # @shape [[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]], false, false 
        # ```
        shape : (point_list, solid = true, closed=true) =>
            if point_list.length is 0 then return
            @ctx.beginPath()
            @ctx.lineTo p[0], p[1] for p in point_list
            if closed
                @ctx.closePath()
                if solid then @ctx.fill() else @ctx.stroke() 
            else 
                if solid then @ctx.fill() else @ctx.stroke() 
                @ctx.closePath()

        # Draws an n-sided polygon
        polygon : (x, y, radius, sides = 3, solid = true) =>
            points = []
            inc = Math.TWO_PI / sides
            for i in [0..sides] by 1
                angle = i * inc
                points.push [x + Math.cos(angle) * radius, y + Math.sin(angle) * radius]
            @shape points, solid, true

       
        # Draws a polygon with n inner sides and n outer sides of
        # ```
        # #Draws a triangle with a hole in the center
        # @polygonRing 100, 100, 20, 60, 30, 3, true 
        # ```
        polygonRing : (x, y, inner_radius, outer_radius, inner_sides = 90, outer_sides = 90, solid = true) =>

            p = {x : 0, y : 0}
            inc = Math.TWO_PI / outer_sides

            @ctx.beginPath()

            for n in [0..outer_sides] by 1
                p.x = x + Math.cos(inc * n) * outer_radius
                p.y = y + Math.sin(inc * n) * outer_radius
                if n is 0
                    @ctx.moveTo p.x, p.y
                else
                    @ctx.lineTo p.x, p.y    

            inc = Math.TWO_PI / inner_sides
            for n in [inner_sides..0] by -1
                p.x = x + Math.cos(inc * n) * inner_radius
                p.y = y + Math.sin(inc * n) * inner_radius
                if n is inner_sides
                    @ctx.moveTo p.x, p.y
                else
                    @ctx.lineTo(p.x, p.y)

            if solid then @ctx.fill() else @ctx.stroke()

        # Returns a random color in rgb format
        randomColor : =>
            return "rgb(" + 
                (Math.floor(Math.random() * 256)).toString() + ',' + 
                (Math.floor(Math.random() * 256)).toString() + ',' +
                (Math.floor(Math.random() * 256)).toString() + ")"

        # Draws a rectangle
        rectangle : (x, y, width, height, solid = true) =>
            if solid then @ctx.fillRect(x, y, width, height) else @ctx.strokeRect(x, y, width, height)  
        # Restores the drawing context
        restoreTransform : =>
            @ctx.restore()

        # Rotates the drawing context
        rotate : (theta) =>
            @ctx.rotate theta

        # Draws a rounded rectangle
        roundedRectangle : (x, y, width, height, corner_radius, solid = true) =>
            @ctx.beginPath();  
            @ctx.moveTo x, y + corner_radius
            @ctx.lineTo x, y + height - corner_radius  
            @ctx.quadraticCurveTo x , y + height, x + corner_radius, y + height  
            @ctx.lineTo x + width - corner_radius, y + height  
            @ctx.quadraticCurveTo x + width, y + height, x + width, y + height - corner_radius  
            @ctx.lineTo x + width, y + corner_radius  
            @ctx.quadraticCurveTo x + width, y , x + width - corner_radius, y
            @ctx.lineTo x + corner_radius, y  
            @ctx.quadraticCurveTo x, y, x, y + corner_radius  
            if solid then @ctx.fill() else @ctx.stroke()

        # Saves the drawing context
        saveTransform : =>
            @ctx.save()

        # Sets the scale of the drawing context
        scale : (x_scale, y_scale) =>
            @ctx.scale x_scale, y_scale

        # Draws text
        text : (x, y, text, solid = true) => 
            if solid then @ctx.fillText(text, x, y) else @ctx.strokeText(text, x, y)
        
        # Translate the drawing context
        translate : (x, y) => 
            @ctx.translate x, y
