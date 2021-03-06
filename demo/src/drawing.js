import Pixelspace from 'lib/pixelspace';

class Drawing extends Pixelspace.Renderer {
  init() {
    this.bg = 'black'
    this.ctx.textAlign = 'left';
  }

  render() {
    this.color('white');
    this.lineStyle(1)
    this.font('14px Terminus');

    // arc()
    this.arc(50, 50, 40, Math.PI, Math.TWO_PI * .75, false);
    this.arc(55, 50, 40, Math.TWO_PI * .75, Math.TWO_PI, false);
    this.arc(55, 55, 40, 0, Math.PI * .5, false);
    this.arc(50, 55, 40, Math.PI * .5, Math.PI, false);
    this.text(35, 110, "arc()");
    
    // circle()
    this.circle(160, 50, 40, false);
    this.circle(160, 50, 20, true);
    this.text(130, 110, "circle()");

    // circles()
    this.ctx.save()
    this.circles([[240, 25], [285, 25], [240, 70], [285, 70]], 15);
    this.color('red');
    this.circles([[240, 25], [285, 25], [240, 70], [285, 70]], 2, false);
    this.ctx.restore();
    this.text(230, 110, "circles()");

    // grid
    this.grid(330, 15, 10, 10, 80, 80);
    this.text(350, 110, "grid()");

    // shape
    this.shape([[420, 10], [520, 30], [540, 90], [500, 80], [460, 60]]);
    this.text(460, 110, "shape()");

    // polygon
    this.polygon(590, 50, 40, 12, false);
    this.polygon(590, 50, 30, 3, false);
    this.polygon(590, 50, 10, 6, false);
    this.text(560, 110, "polygon()");

    // polygonRing
    this.polygonRing(720, 50, 20, 50, 6, 6);
    this.text(670, 110, "polygonRing()")

    // roundedRectangle
    this.roundedRectangle(830, 10, 80, 80, 10);
    this.text(800, 110, "roundedRectangle()");
  }
}

module.exports = Drawing;
