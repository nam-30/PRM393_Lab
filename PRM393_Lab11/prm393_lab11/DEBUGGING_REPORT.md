# LAB 11.4 — DEVTOOLS DEBUGGING & PERFORMANCE REPORT

**App Name:** Taskly App (Flutter)  
**Module:** PRM393 - Mobile Development  
**Author:** Lê Hoài Nam  

---

## 1. DevTools Widget Inspector Analysis

### 1.1 Widget Tree Hierarchy
The widget tree structure of the Taskly App was inspected using **Flutter DevTools Widget Inspector**:
```
MaterialApp
 └── TaskListScreen
      └── Scaffold
           ├── AppBar ("Taskly - My Tasks")
           └── Column
                ├── Row (TextField + ElevatedButton)
                └── Expanded
                     └── ListView.builder / Center (Empty State)
                          └── Card
                               └── ListTile (Checkbox, Text, IconButton)
```

### 1.2 Layout Constraints Inspection
- **Flex Overflow Prevention:** The task title input field is wrapped inside an `Expanded` widget within the horizontal `Row` to prevent render overflow (`RenderFlex overflowed by ... pixels`).
- **Scroll Constraints:** The `ListView.builder` is wrapped inside an `Expanded` widget within the vertical `Column` to grant bounded height constraints.

---

## 2. DevTools Performance Timeline Analysis

### 2.1 Frame Rendering & Rebuild Frequency
- **Frame Rate:** Maintained a stable 60 FPS (16.6ms per frame budget) during user interactions (adding, toggling, and deleting tasks).
- **Rebuild Optimization:** Task item state changes (e.g. checkbox completion toggle) trigger state updates at the `TaskListScreen` level. Using `const` constructors for static widgets (such as AppBars and Labels) minimizes unnecessary rebuilds in the widget subtree.

---

## 3. Potential Bottlenecks & Remediation

| Potential Issue | Impact | Detection Tool | Solution / Remediation |
| :--- | :--- | :--- | :--- |
| **Unbounded ListView inside Column** | `Vertical viewport was given unbounded height` crash | DevTools Widget Inspector | Wrap `ListView.builder` inside `Expanded` or `SizedBox` with explicit height. |
| **Unbounded TextField inside Row** | `RenderFlex overflowed by ... pixels` layout error | Layout Explorer | Wrap `TextField` inside `Expanded` in horizontal `Row` widgets. |
| **Excessive Widget Rebuilds** | UI lag when list contains 100+ tasks | Performance Timeline & Repaint Rainbow | Use `ListView.builder` instead of `ListView(children: ...)` for lazy loading. Use `const` widgets. |

---

## 4. Conclusion
Using **Flutter DevTools Widget Inspector** and **Performance Timeline** alongside comprehensive unit/widget tests ensures early detection of layout constraints and UI bottlenecks before deployment.
