import org.processing.wiki.triangulate.*;

BubbleGrid grid;
color bg = color(0);

void setup() {
  size(600, 480);
  grid = new BubbleGrid(width, height);
  noStroke();
  smooth();
}

void draw() {
  background(bg);
  grid.update();
  grid.renderBubbles();
}

void mouseClicked() {
  grid.clear();
  loop();
}
