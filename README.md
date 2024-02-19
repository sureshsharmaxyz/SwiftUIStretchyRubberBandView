## SwiftUI Stretchy Rubber Band View

Recreation of the rubber band + stretch effect seen in @rickwaalders post on X: 
https://x.com/rickwaalders/status/1759180830784569678

### Step 1 - Dragging the view:
- Add a drag gesture to offset the view
- Reset the dragOffset to zero with a spring animation when the drag ends

### Step 2 - Constrain the drag
- The naive approach:
  - Limit the width and height of the drag
  - Causes the view to be bound within a square, which is not exactly ideal

- The better solution:
    - Ideally, we want to limit the max distance that the view can be dragged away from the center
    - This constrains the view within a circle, which feels nicer

### Step 3 - Add the stretch
- Add a scale effect to the view
- The longer the width and height of the drag's translation, the more the view scales in x and y respectively
- I played around with these numbers until the interaction felt good

### Step 4 - Add haptics for some extra juice
- The further you drag, the longer the stretch and the higher the haptic feedback intensity
- And finally, the standard success feedback felt great when letting go and watching the view snap back

Code is on github here: 