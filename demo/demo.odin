package demo

import yg "../"
import "core:fmt"
import "core:math"

main :: proc() {
    undefined := math.nan_f32()

    // --- build the tree ---
    root := yg.NodeNew()
    defer yg.NodeFreeRecursive(root)

    yg.NodeStyleSetWidth(root, 800)
    yg.NodeStyleSetHeight(root, 600)
    yg.NodeStyleSetFlexDirection(root, .Column)
    yg.NodeStyleSetPadding(root, .All, 16)
    yg.NodeStyleSetGap(root, .All, 8)

    // header
    header := yg.NodeNew()
    yg.NodeStyleSetWidth(header, undefined) // stretch by default
    yg.NodeStyleSetHeight(header, 60)
    yg.NodeInsertChild(root, header, 0)

    // content row
    row := yg.NodeNew()
    yg.NodeStyleSetFlexDirection(row, .Row)
    yg.NodeStyleSetFlexGrow(row, 1) // take remaining space
    yg.NodeStyleSetGap(row, .All, 8)
    yg.NodeInsertChild(root, row, 1)

    // sidebar
    sidebar := yg.NodeNew()
    yg.NodeStyleSetWidth(sidebar, 200)
    yg.NodeStyleSetFlexShrink(sidebar, 0)
    yg.NodeInsertChild(row, sidebar, 0)

    // main panel
    main_panel := yg.NodeNew()
    yg.NodeStyleSetFlexGrow(main_panel, 1)
    yg.NodeInsertChild(row, main_panel, 1)

    // --- calculate layout ---
    yg.NodeCalculateLayout(root, undefined, undefined, .LTR)

    // --- read results ---
    fmt.printf(
        "root:       x=%.0f y=%.0f w=%.0f h=%.0f\n",
        yg.NodeLayoutGetLeft(root),
        yg.NodeLayoutGetTop(root),
        yg.NodeLayoutGetWidth(root),
        yg.NodeLayoutGetHeight(root),
    )
    fmt.printf(
        "header:     x=%.0f y=%.0f w=%.0f h=%.0f\n",
        yg.NodeLayoutGetLeft(header),
        yg.NodeLayoutGetTop(header),
        yg.NodeLayoutGetWidth(header),
        yg.NodeLayoutGetHeight(header),
    )
    fmt.printf(
        "row:        x=%.0f y=%.0f w=%.0f h=%.0f\n",
        yg.NodeLayoutGetLeft(row),
        yg.NodeLayoutGetTop(row),
        yg.NodeLayoutGetWidth(row),
        yg.NodeLayoutGetHeight(row),
    )
    fmt.printf(
        "sidebar:    x=%.0f y=%.0f w=%.0f h=%.0f\n",
        yg.NodeLayoutGetLeft(sidebar),
        yg.NodeLayoutGetTop(sidebar),
        yg.NodeLayoutGetWidth(sidebar),
        yg.NodeLayoutGetHeight(sidebar),
    )
    fmt.printf(
        "main_panel: x=%.0f y=%.0f w=%.0f h=%.0f\n",
        yg.NodeLayoutGetLeft(main_panel),
        yg.NodeLayoutGetTop(main_panel),
        yg.NodeLayoutGetWidth(main_panel),
        yg.NodeLayoutGetHeight(main_panel),
    )
}

