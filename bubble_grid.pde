class BubbleGrid {
  private int frameWidth;
  private int frameHeight;
  private int bubbleLimit;

  private int updates;
  private float maxRadius;
  private float maxUpdates;

  private ArrayList<Bubble> bubbles;
  private ArrayList<Triangle> triangles;

  public BubbleGrid(int frameWidth, int frameHeight) {
    this.frameWidth = frameWidth;
    this.frameHeight = frameHeight;
    this.bubbles = new ArrayList<Bubble>();
    this.triangles = new ArrayList<Triangle>();
    this.bubbleLimit = round(frameWidth * frameHeight / (2*START_RADIUS*START_RADIUS));
    this.updates = 0;
  }

  public void update() {
    updateBubbles();
    add();
    updates++;
  }

  public void add() {
    if (bubbleLimit > bubblesCount()) {
      Bubble bubble;
      do {
        bubble = new Bubble(frameWidth, frameHeight);
      } while(!add(bubble));

      if (2 < bubblesCount()) {
        for(Bubble b : bubbles) {
          b.clearNeighbors();
        }
        triangles = Triangulate.triangulate((ArrayList)bubbles);
        for(Triangle triangle : triangles) {
          ((Bubble)triangle.p1).addNeighbor((Bubble)triangle.p2);
          ((Bubble)triangle.p1).addNeighbor((Bubble)triangle.p3);
          ((Bubble)triangle.p2).addNeighbor((Bubble)triangle.p1);
          ((Bubble)triangle.p2).addNeighbor((Bubble)triangle.p3);
          ((Bubble)triangle.p3).addNeighbor((Bubble)triangle.p1);
          ((Bubble)triangle.p3).addNeighbor((Bubble)triangle.p2);
        }
      }
    }
  }

  private void updateBubbles() {
    ArrayList<Bubble> deadBubbles = new ArrayList<Bubble>();
    maxRadius = 0;
    maxUpdates = 0;
    for(Bubble bubble : bubbles) {
      bubble.update();
      if (bubble.dead()) {
        deadBubbles.add(bubble);
      } else {
        if (maxRadius < bubble.radius()) {
          maxRadius = bubble.radius();
        }
        if (maxUpdates < bubble.updates()) {
          maxUpdates = bubble.updates();
        }
      }
    }
    for(Bubble deadBubble : deadBubbles) {
      bubbles.remove(deadBubble);
    }
  }

  private boolean add(Bubble bubble) {
    for(Bubble old : bubbles) {
      if (bubble.overlapses(old)) {
        return false;
      }
    }
    bubbles.add(bubble);
    return true;
  }

  public void clear() {
    triangles.clear();
    bubbles.clear();
  }

  public int bubblesCount() {
    return bubbles.size();
  }

  public int trianglesCount() {
    return triangles.size();
  }

  public void renderBubbles() {
    colorMode(HSB, 360, 1.0, 1.0, maxRadius);
    for(Bubble bubble : bubbles) {
      bubble.render();
    }
  }

  public void renderTriangles() {
    beginShape(TRIANGLES);
    for (Triangle t : triangles) {
      vertex(t.p1.x, t.p1.y);
      vertex(t.p2.x, t.p2.y);
      vertex(t.p3.x, t.p3.y);
    }
    endShape();
  }
}
