package yoga

import "core:c"

LINK :: #config(YOGA_LINK, "shared")

when ODIN_OS == .Windows {
    when LINK == "static" {
        foreign import lib "yoga_static.lib"
    } else {
        foreign import lib "yoga.lib"
    }
} else when ODIN_OS == .Darwin {
    @(require) foreign import stdcpp "system:c++"
    when LINK == "static" {
        foreign import lib "libyoga.darwin.a"
    } else {
        foreign import lib "libyoga.dylib"
    }
} else when ODIN_OS == .Linux {
    @(require) foreign import stdcpp "system:c++"
    when LINK == "static" {
        foreign import lib "libyoga.linux.a"
    } else {
        foreign import lib "libyoga.so"
    }
} else when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    // Import yoga.wasm.a from your build pipeline when targeting wasm.
}

Node :: struct {}
Config :: struct {}

Node_Ref :: ^Node
Node_Const_Ref :: ^Node
Config_Ref :: ^Config
Config_Const_Ref :: ^Config

Align :: enum c.int {
    Auto,
    FlexStart,
    Center,
    FlexEnd,
    Stretch,
    Baseline,
    SpaceBetween,
    SpaceAround,
    SpaceEvenly,
}

Box_Sizing :: enum c.int {
    BorderBox,
    ContentBox,
}

Dimension :: enum c.int {
    Width,
    Height,
}

Direction :: enum c.int {
    Inherit,
    LTR,
    RTL,
}

Display :: enum c.int {
    Flex,
    None,
    Contents,
}

Edge :: enum c.int {
    Left,
    Top,
    Right,
    Bottom,
    Start,
    End,
    Horizontal,
    Vertical,
    All,
}

Errata :: enum c.int {
    None                                         = 0,
    StretchFlexBasis                             = 1,
    AbsolutePositionWithoutInsetsExcludesPadding = 2,
    AbsolutePercentAgainstInnerSize              = 4,
    All                                          = 0x7fffffff,
    Classic                                      = 0x7ffffffe,
}

Experimental_Feature :: enum c.int {
    WebFlexBasis,
}

Flex_Direction :: enum c.int {
    Column,
    ColumnReverse,
    Row,
    RowReverse,
}

Gutter :: enum c.int {
    Column,
    Row,
    All,
}

Justify :: enum c.int {
    FlexStart,
    Center,
    FlexEnd,
    SpaceBetween,
    SpaceAround,
    SpaceEvenly,
}

Log_Level :: enum c.int {
    Error,
    Warn,
    Info,
    Debug,
    Verbose,
    Fatal,
}

Measure_Mode :: enum c.int {
    Undefined,
    Exactly,
    AtMost,
}

Node_Type :: enum c.int {
    Default,
    Text,
}

Overflow :: enum c.int {
    Visible,
    Hidden,
    Scroll,
}

Position_Type :: enum c.int {
    Static,
    Relative,
    Absolute,
}

Unit :: enum c.int {
    Undefined,
    Point,
    Percent,
    Auto,
    MaxContent,
    FitContent,
    Stretch,
}

Wrap :: enum c.int {
    NoWrap,
    Wrap,
    WrapReverse,
}

Size :: struct {
    width:  f32,
    height: f32,
}

Value :: struct {
    value: f32,
    unit:  Unit,
}

Value_Auto :: Value{0, .Auto}
Value_Undefined :: Value{0, .Undefined}
Value_Zero :: Value{0, .Point}

Dirtied_Func :: #type proc "c" (node: Node_Const_Ref)
Measure_Func :: #type proc "c" (
    node: Node_Const_Ref,
    width: f32,
    widthMode: Measure_Mode,
    height: f32,
    heightMode: Measure_Mode,
) -> Size
Baseline_Func :: #type proc "c" (node: Node_Const_Ref, width, height: f32) -> f32
Logger :: #type proc "c" (
    config: Config_Const_Ref,
    node: Node_Const_Ref,
    level: Log_Level,
    format: cstring,
    args: rawptr,
) -> c.int
Clone_Node_Func :: #type proc "c" (oldNode: Node_Const_Ref, owner: Node_Const_Ref, childIndex: c.size_t) -> Node_Ref

when ODIN_ARCH == .wasm32 || ODIN_ARCH == .wasm64p32 {
    @(default_calling_convention = "c", link_prefix = "YG")
    foreign _ {
        AlignToString :: proc(value: Align) -> cstring ---
        BoxSizingToString :: proc(value: Box_Sizing) -> cstring ---
        DimensionToString :: proc(value: Dimension) -> cstring ---
        DirectionToString :: proc(value: Direction) -> cstring ---
        DisplayToString :: proc(value: Display) -> cstring ---
        EdgeToString :: proc(value: Edge) -> cstring ---
        ErrataToString :: proc(value: Errata) -> cstring ---
        ExperimentalFeatureToString :: proc(value: Experimental_Feature) -> cstring ---
        FlexDirectionToString :: proc(value: Flex_Direction) -> cstring ---
        GutterToString :: proc(value: Gutter) -> cstring ---
        JustifyToString :: proc(value: Justify) -> cstring ---
        LogLevelToString :: proc(value: Log_Level) -> cstring ---
        MeasureModeToString :: proc(value: Measure_Mode) -> cstring ---
        NodeTypeToString :: proc(value: Node_Type) -> cstring ---
        OverflowToString :: proc(value: Overflow) -> cstring ---
        PositionTypeToString :: proc(value: Position_Type) -> cstring ---
        UnitToString :: proc(value: Unit) -> cstring ---
        WrapToString :: proc(value: Wrap) -> cstring ---

        FloatIsUndefined :: proc(value: f32) -> bool ---

        ConfigNew :: proc() -> Config_Ref ---
        ConfigFree :: proc(config: Config_Ref) ---
        ConfigGetDefault :: proc() -> Config_Const_Ref ---
        ConfigSetUseWebDefaults :: proc(config: Config_Ref, enabled: bool) ---
        ConfigGetUseWebDefaults :: proc(config: Config_Const_Ref) -> bool ---
        ConfigSetPointScaleFactor :: proc(config: Config_Ref, pixelsInPoint: f32) ---
        ConfigGetPointScaleFactor :: proc(config: Config_Const_Ref) -> f32 ---
        ConfigSetErrata :: proc(config: Config_Ref, errata: Errata) ---
        ConfigGetErrata :: proc(config: Config_Const_Ref) -> Errata ---
        ConfigSetLogger :: proc(config: Config_Ref, logger: Logger) ---
        ConfigSetContext :: proc(config: Config_Ref, ctx: rawptr) ---
        ConfigGetContext :: proc(config: Config_Const_Ref) -> rawptr ---
        ConfigSetExperimentalFeatureEnabled :: proc(config: Config_Ref, feature: Experimental_Feature, enabled: bool) ---
        ConfigIsExperimentalFeatureEnabled :: proc(config: Config_Const_Ref, feature: Experimental_Feature) -> bool ---
        ConfigSetCloneNodeFunc :: proc(config: Config_Ref, callback: Clone_Node_Func) ---

        NodeNew :: proc() -> Node_Ref ---
        NodeNewWithConfig :: proc(config: Config_Const_Ref) -> Node_Ref ---
        NodeClone :: proc(node: Node_Const_Ref) -> Node_Ref ---
        NodeFree :: proc(node: Node_Ref) ---
        NodeFreeRecursive :: proc(node: Node_Ref) ---
        NodeFinalize :: proc(node: Node_Ref) ---
        NodeReset :: proc(node: Node_Ref) ---
        NodeCalculateLayout :: proc(node: Node_Ref, availableWidth, availableHeight: f32, ownerDirection: Direction) ---
        NodeGetHasNewLayout :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetHasNewLayout :: proc(node: Node_Ref, hasNewLayout: bool) ---
        NodeIsDirty :: proc(node: Node_Const_Ref) -> bool ---
        NodeMarkDirty :: proc(node: Node_Ref) ---
        NodeSetDirtiedFunc :: proc(node: Node_Ref, dirtiedFunc: Dirtied_Func) ---
        NodeGetDirtiedFunc :: proc(node: Node_Const_Ref) -> Dirtied_Func ---
        NodeInsertChild :: proc(node: Node_Ref, child: Node_Ref, index: c.size_t) ---
        NodeSwapChild :: proc(node: Node_Ref, child: Node_Ref, index: c.size_t) ---
        NodeRemoveChild :: proc(node: Node_Ref, child: Node_Ref) ---
        NodeRemoveAllChildren :: proc(node: Node_Ref) ---
        NodeSetChildren :: proc(owner: Node_Ref, children: [^]Node_Ref, count: c.size_t) ---
        NodeGetChild :: proc(node: Node_Ref, index: c.size_t) -> Node_Ref ---
        NodeGetChildCount :: proc(node: Node_Const_Ref) -> c.size_t ---
        NodeGetOwner :: proc(node: Node_Ref) -> Node_Ref ---
        NodeGetParent :: proc(node: Node_Ref) -> Node_Ref ---
        NodeSetConfig :: proc(node: Node_Ref, config: Config_Ref) ---
        NodeGetConfig :: proc(node: Node_Ref) -> Config_Const_Ref ---
        NodeSetContext :: proc(node: Node_Ref, ctx: rawptr) ---
        NodeGetContext :: proc(node: Node_Const_Ref) -> rawptr ---
        NodeSetMeasureFunc :: proc(node: Node_Ref, measureFunc: Measure_Func) ---
        NodeHasMeasureFunc :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetBaselineFunc :: proc(node: Node_Ref, baselineFunc: Baseline_Func) ---
        NodeHasBaselineFunc :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetIsReferenceBaseline :: proc(node: Node_Ref, isReferenceBaseline: bool) ---
        NodeIsReferenceBaseline :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetNodeType :: proc(node: Node_Ref, nodeType: Node_Type) ---
        NodeGetNodeType :: proc(node: Node_Const_Ref) -> Node_Type ---
        NodeSetAlwaysFormsContainingBlock :: proc(node: Node_Ref, alwaysFormsContainingBlock: bool) ---
        NodeGetAlwaysFormsContainingBlock :: proc(node: Node_Const_Ref) -> bool ---
        NodeCanUseCachedMeasurement :: proc(widthMode: Measure_Mode, availableWidth: f32, heightMode: Measure_Mode, availableHeight: f32, lastWidthMode: Measure_Mode, lastAvailableWidth: f32, lastHeightMode: Measure_Mode, lastAvailableHeight: f32, lastComputedWidth: f32, lastComputedHeight: f32, marginRow: f32, marginColumn: f32, config: Config_Ref) -> bool ---

        NodeCopyStyle :: proc(dstNode: Node_Ref, srcNode: Node_Const_Ref) ---

        NodeStyleSetDirection :: proc(node: Node_Ref, direction: Direction) ---
        NodeStyleGetDirection :: proc(node: Node_Const_Ref) -> Direction ---
        NodeStyleSetFlexDirection :: proc(node: Node_Ref, flexDirection: Flex_Direction) ---
        NodeStyleGetFlexDirection :: proc(node: Node_Const_Ref) -> Flex_Direction ---
        NodeStyleSetJustifyContent :: proc(node: Node_Ref, justifyContent: Justify) ---
        NodeStyleGetJustifyContent :: proc(node: Node_Const_Ref) -> Justify ---
        NodeStyleSetAlignContent :: proc(node: Node_Ref, alignContent: Align) ---
        NodeStyleGetAlignContent :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetAlignItems :: proc(node: Node_Ref, alignItems: Align) ---
        NodeStyleGetAlignItems :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetAlignSelf :: proc(node: Node_Ref, alignSelf: Align) ---
        NodeStyleGetAlignSelf :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetPositionType :: proc(node: Node_Ref, positionType: Position_Type) ---
        NodeStyleGetPositionType :: proc(node: Node_Const_Ref) -> Position_Type ---
        NodeStyleSetFlexWrap :: proc(node: Node_Ref, flexWrap: Wrap) ---
        NodeStyleGetFlexWrap :: proc(node: Node_Const_Ref) -> Wrap ---
        NodeStyleSetOverflow :: proc(node: Node_Ref, overflow: Overflow) ---
        NodeStyleGetOverflow :: proc(node: Node_Const_Ref) -> Overflow ---
        NodeStyleSetDisplay :: proc(node: Node_Ref, display: Display) ---
        NodeStyleGetDisplay :: proc(node: Node_Const_Ref) -> Display ---
        NodeStyleSetFlex :: proc(node: Node_Ref, flex: f32) ---
        NodeStyleGetFlex :: proc(node: Node_Const_Ref) -> f32 ---
        NodeStyleSetFlexGrow :: proc(node: Node_Ref, flexGrow: f32) ---
        NodeStyleGetFlexGrow :: proc(node: Node_Const_Ref) -> f32 ---
        NodeStyleSetFlexShrink :: proc(node: Node_Ref, flexShrink: f32) ---
        NodeStyleGetFlexShrink :: proc(node: Node_Const_Ref) -> f32 ---

        NodeStyleSetFlexBasis :: proc(node: Node_Ref, flexBasis: f32) ---
        NodeStyleSetFlexBasisPercent :: proc(node: Node_Ref, flexBasis: f32) ---
        NodeStyleSetFlexBasisAuto :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisStretch :: proc(node: Node_Ref) ---
        NodeStyleGetFlexBasis :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetPosition :: proc(node: Node_Ref, edge: Edge, position: f32) ---
        NodeStyleSetPositionPercent :: proc(node: Node_Ref, edge: Edge, position: f32) ---
        NodeStyleSetPositionAuto :: proc(node: Node_Ref, edge: Edge) ---
        NodeStyleGetPosition :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetMargin :: proc(node: Node_Ref, edge: Edge, margin: f32) ---
        NodeStyleSetMarginPercent :: proc(node: Node_Ref, edge: Edge, margin: f32) ---
        NodeStyleSetMarginAuto :: proc(node: Node_Ref, edge: Edge) ---
        NodeStyleGetMargin :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetPadding :: proc(node: Node_Ref, edge: Edge, padding: f32) ---
        NodeStyleSetPaddingPercent :: proc(node: Node_Ref, edge: Edge, padding: f32) ---
        NodeStyleGetPadding :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetBorder :: proc(node: Node_Ref, edge: Edge, border: f32) ---
        NodeStyleGetBorder :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---

        NodeStyleSetGap :: proc(node: Node_Ref, gutter: Gutter, gapLength: f32) ---
        NodeStyleSetGapPercent :: proc(node: Node_Ref, gutter: Gutter, gapLength: f32) ---
        NodeStyleGetGap :: proc(node: Node_Const_Ref, gutter: Gutter) -> Value ---

        NodeStyleSetBoxSizing :: proc(node: Node_Ref, boxSizing: Box_Sizing) ---
        NodeStyleGetBoxSizing :: proc(node: Node_Const_Ref) -> Box_Sizing ---

        NodeStyleSetWidth :: proc(node: Node_Ref, width: f32) ---
        NodeStyleSetWidthPercent :: proc(node: Node_Ref, width: f32) ---
        NodeStyleSetWidthAuto :: proc(node: Node_Ref) ---
        NodeStyleSetWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetHeight :: proc(node: Node_Ref, height: f32) ---
        NodeStyleSetHeightPercent :: proc(node: Node_Ref, height: f32) ---
        NodeStyleSetHeightAuto :: proc(node: Node_Ref) ---
        NodeStyleSetHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMinWidth :: proc(node: Node_Ref, minWidth: f32) ---
        NodeStyleSetMinWidthPercent :: proc(node: Node_Ref, minWidth: f32) ---
        NodeStyleSetMinWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMinWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMinHeight :: proc(node: Node_Ref, minHeight: f32) ---
        NodeStyleSetMinHeightPercent :: proc(node: Node_Ref, minHeight: f32) ---
        NodeStyleSetMinHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMinHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMaxWidth :: proc(node: Node_Ref, maxWidth: f32) ---
        NodeStyleSetMaxWidthPercent :: proc(node: Node_Ref, maxWidth: f32) ---
        NodeStyleSetMaxWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMaxWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMaxHeight :: proc(node: Node_Ref, maxHeight: f32) ---
        NodeStyleSetMaxHeightPercent :: proc(node: Node_Ref, maxHeight: f32) ---
        NodeStyleSetMaxHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMaxHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetAspectRatio :: proc(node: Node_Ref, aspectRatio: f32) ---
        NodeStyleGetAspectRatio :: proc(node: Node_Const_Ref) -> f32 ---

        NodeLayoutGetLeft :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetTop :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetRight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetBottom :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetWidth :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetHeight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetDirection :: proc(node: Node_Const_Ref) -> Direction ---
        NodeLayoutGetHadOverflow :: proc(node: Node_Const_Ref) -> bool ---
        NodeLayoutGetMargin :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetBorder :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetPadding :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetRawHeight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetRawWidth :: proc(node: Node_Const_Ref) -> f32 ---

        RoundValueToPixelGrid :: proc(value, pointScaleFactor: f64, forceCeil, forceFloor: bool) -> f32 ---
    }
} else {
    @(default_calling_convention = "c", link_prefix = "YG")
    foreign lib {
        AlignToString :: proc(value: Align) -> cstring ---
        BoxSizingToString :: proc(value: Box_Sizing) -> cstring ---
        DimensionToString :: proc(value: Dimension) -> cstring ---
        DirectionToString :: proc(value: Direction) -> cstring ---
        DisplayToString :: proc(value: Display) -> cstring ---
        EdgeToString :: proc(value: Edge) -> cstring ---
        ErrataToString :: proc(value: Errata) -> cstring ---
        ExperimentalFeatureToString :: proc(value: Experimental_Feature) -> cstring ---
        FlexDirectionToString :: proc(value: Flex_Direction) -> cstring ---
        GutterToString :: proc(value: Gutter) -> cstring ---
        JustifyToString :: proc(value: Justify) -> cstring ---
        LogLevelToString :: proc(value: Log_Level) -> cstring ---
        MeasureModeToString :: proc(value: Measure_Mode) -> cstring ---
        NodeTypeToString :: proc(value: Node_Type) -> cstring ---
        OverflowToString :: proc(value: Overflow) -> cstring ---
        PositionTypeToString :: proc(value: Position_Type) -> cstring ---
        UnitToString :: proc(value: Unit) -> cstring ---
        WrapToString :: proc(value: Wrap) -> cstring ---

        FloatIsUndefined :: proc(value: f32) -> bool ---

        ConfigNew :: proc() -> Config_Ref ---
        ConfigFree :: proc(config: Config_Ref) ---
        ConfigGetDefault :: proc() -> Config_Const_Ref ---
        ConfigSetUseWebDefaults :: proc(config: Config_Ref, enabled: bool) ---
        ConfigGetUseWebDefaults :: proc(config: Config_Const_Ref) -> bool ---
        ConfigSetPointScaleFactor :: proc(config: Config_Ref, pixelsInPoint: f32) ---
        ConfigGetPointScaleFactor :: proc(config: Config_Const_Ref) -> f32 ---
        ConfigSetErrata :: proc(config: Config_Ref, errata: Errata) ---
        ConfigGetErrata :: proc(config: Config_Const_Ref) -> Errata ---
        ConfigSetLogger :: proc(config: Config_Ref, logger: Logger) ---
        ConfigSetContext :: proc(config: Config_Ref, ctx: rawptr) ---
        ConfigGetContext :: proc(config: Config_Const_Ref) -> rawptr ---
        ConfigSetExperimentalFeatureEnabled :: proc(config: Config_Ref, feature: Experimental_Feature, enabled: bool) ---
        ConfigIsExperimentalFeatureEnabled :: proc(config: Config_Const_Ref, feature: Experimental_Feature) -> bool ---
        ConfigSetCloneNodeFunc :: proc(config: Config_Ref, callback: Clone_Node_Func) ---

        NodeNew :: proc() -> Node_Ref ---
        NodeNewWithConfig :: proc(config: Config_Const_Ref) -> Node_Ref ---
        NodeClone :: proc(node: Node_Const_Ref) -> Node_Ref ---
        NodeFree :: proc(node: Node_Ref) ---
        NodeFreeRecursive :: proc(node: Node_Ref) ---
        NodeFinalize :: proc(node: Node_Ref) ---
        NodeReset :: proc(node: Node_Ref) ---
        NodeCalculateLayout :: proc(node: Node_Ref, availableWidth, availableHeight: f32, ownerDirection: Direction) ---
        NodeGetHasNewLayout :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetHasNewLayout :: proc(node: Node_Ref, hasNewLayout: bool) ---
        NodeIsDirty :: proc(node: Node_Const_Ref) -> bool ---
        NodeMarkDirty :: proc(node: Node_Ref) ---
        NodeSetDirtiedFunc :: proc(node: Node_Ref, dirtiedFunc: Dirtied_Func) ---
        NodeGetDirtiedFunc :: proc(node: Node_Const_Ref) -> Dirtied_Func ---
        NodeInsertChild :: proc(node: Node_Ref, child: Node_Ref, index: c.size_t) ---
        NodeSwapChild :: proc(node: Node_Ref, child: Node_Ref, index: c.size_t) ---
        NodeRemoveChild :: proc(node: Node_Ref, child: Node_Ref) ---
        NodeRemoveAllChildren :: proc(node: Node_Ref) ---
        NodeSetChildren :: proc(owner: Node_Ref, children: [^]Node_Ref, count: c.size_t) ---
        NodeGetChild :: proc(node: Node_Ref, index: c.size_t) -> Node_Ref ---
        NodeGetChildCount :: proc(node: Node_Const_Ref) -> c.size_t ---
        NodeGetOwner :: proc(node: Node_Ref) -> Node_Ref ---
        NodeGetParent :: proc(node: Node_Ref) -> Node_Ref ---
        NodeSetConfig :: proc(node: Node_Ref, config: Config_Ref) ---
        NodeGetConfig :: proc(node: Node_Ref) -> Config_Const_Ref ---
        NodeSetContext :: proc(node: Node_Ref, ctx: rawptr) ---
        NodeGetContext :: proc(node: Node_Const_Ref) -> rawptr ---
        NodeSetMeasureFunc :: proc(node: Node_Ref, measureFunc: Measure_Func) ---
        NodeHasMeasureFunc :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetBaselineFunc :: proc(node: Node_Ref, baselineFunc: Baseline_Func) ---
        NodeHasBaselineFunc :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetIsReferenceBaseline :: proc(node: Node_Ref, isReferenceBaseline: bool) ---
        NodeIsReferenceBaseline :: proc(node: Node_Const_Ref) -> bool ---
        NodeSetNodeType :: proc(node: Node_Ref, nodeType: Node_Type) ---
        NodeGetNodeType :: proc(node: Node_Const_Ref) -> Node_Type ---
        NodeSetAlwaysFormsContainingBlock :: proc(node: Node_Ref, alwaysFormsContainingBlock: bool) ---
        NodeGetAlwaysFormsContainingBlock :: proc(node: Node_Const_Ref) -> bool ---
        NodeCanUseCachedMeasurement :: proc(widthMode: Measure_Mode, availableWidth: f32, heightMode: Measure_Mode, availableHeight: f32, lastWidthMode: Measure_Mode, lastAvailableWidth: f32, lastHeightMode: Measure_Mode, lastAvailableHeight: f32, lastComputedWidth: f32, lastComputedHeight: f32, marginRow: f32, marginColumn: f32, config: Config_Ref) -> bool ---

        NodeCopyStyle :: proc(dstNode: Node_Ref, srcNode: Node_Const_Ref) ---

        NodeStyleSetDirection :: proc(node: Node_Ref, direction: Direction) ---
        NodeStyleGetDirection :: proc(node: Node_Const_Ref) -> Direction ---
        NodeStyleSetFlexDirection :: proc(node: Node_Ref, flexDirection: Flex_Direction) ---
        NodeStyleGetFlexDirection :: proc(node: Node_Const_Ref) -> Flex_Direction ---
        NodeStyleSetJustifyContent :: proc(node: Node_Ref, justifyContent: Justify) ---
        NodeStyleGetJustifyContent :: proc(node: Node_Const_Ref) -> Justify ---
        NodeStyleSetAlignContent :: proc(node: Node_Ref, alignContent: Align) ---
        NodeStyleGetAlignContent :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetAlignItems :: proc(node: Node_Ref, alignItems: Align) ---
        NodeStyleGetAlignItems :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetAlignSelf :: proc(node: Node_Ref, alignSelf: Align) ---
        NodeStyleGetAlignSelf :: proc(node: Node_Const_Ref) -> Align ---
        NodeStyleSetPositionType :: proc(node: Node_Ref, positionType: Position_Type) ---
        NodeStyleGetPositionType :: proc(node: Node_Const_Ref) -> Position_Type ---
        NodeStyleSetFlexWrap :: proc(node: Node_Ref, flexWrap: Wrap) ---
        NodeStyleGetFlexWrap :: proc(node: Node_Const_Ref) -> Wrap ---
        NodeStyleSetOverflow :: proc(node: Node_Ref, overflow: Overflow) ---
        NodeStyleGetOverflow :: proc(node: Node_Const_Ref) -> Overflow ---
        NodeStyleSetDisplay :: proc(node: Node_Ref, display: Display) ---
        NodeStyleGetDisplay :: proc(node: Node_Const_Ref) -> Display ---
        NodeStyleSetFlex :: proc(node: Node_Ref, flex: f32) ---
        NodeStyleGetFlex :: proc(node: Node_Const_Ref) -> f32 ---
        NodeStyleSetFlexGrow :: proc(node: Node_Ref, flexGrow: f32) ---
        NodeStyleGetFlexGrow :: proc(node: Node_Const_Ref) -> f32 ---
        NodeStyleSetFlexShrink :: proc(node: Node_Ref, flexShrink: f32) ---
        NodeStyleGetFlexShrink :: proc(node: Node_Const_Ref) -> f32 ---

        NodeStyleSetFlexBasis :: proc(node: Node_Ref, flexBasis: f32) ---
        NodeStyleSetFlexBasisPercent :: proc(node: Node_Ref, flexBasis: f32) ---
        NodeStyleSetFlexBasisAuto :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetFlexBasisStretch :: proc(node: Node_Ref) ---
        NodeStyleGetFlexBasis :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetPosition :: proc(node: Node_Ref, edge: Edge, position: f32) ---
        NodeStyleSetPositionPercent :: proc(node: Node_Ref, edge: Edge, position: f32) ---
        NodeStyleSetPositionAuto :: proc(node: Node_Ref, edge: Edge) ---
        NodeStyleGetPosition :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetMargin :: proc(node: Node_Ref, edge: Edge, margin: f32) ---
        NodeStyleSetMarginPercent :: proc(node: Node_Ref, edge: Edge, margin: f32) ---
        NodeStyleSetMarginAuto :: proc(node: Node_Ref, edge: Edge) ---
        NodeStyleGetMargin :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetPadding :: proc(node: Node_Ref, edge: Edge, padding: f32) ---
        NodeStyleSetPaddingPercent :: proc(node: Node_Ref, edge: Edge, padding: f32) ---
        NodeStyleGetPadding :: proc(node: Node_Const_Ref, edge: Edge) -> Value ---

        NodeStyleSetBorder :: proc(node: Node_Ref, edge: Edge, border: f32) ---
        NodeStyleGetBorder :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---

        NodeStyleSetGap :: proc(node: Node_Ref, gutter: Gutter, gapLength: f32) ---
        NodeStyleSetGapPercent :: proc(node: Node_Ref, gutter: Gutter, gapLength: f32) ---
        NodeStyleGetGap :: proc(node: Node_Const_Ref, gutter: Gutter) -> Value ---

        NodeStyleSetBoxSizing :: proc(node: Node_Ref, boxSizing: Box_Sizing) ---
        NodeStyleGetBoxSizing :: proc(node: Node_Const_Ref) -> Box_Sizing ---

        NodeStyleSetWidth :: proc(node: Node_Ref, width: f32) ---
        NodeStyleSetWidthPercent :: proc(node: Node_Ref, width: f32) ---
        NodeStyleSetWidthAuto :: proc(node: Node_Ref) ---
        NodeStyleSetWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetHeight :: proc(node: Node_Ref, height: f32) ---
        NodeStyleSetHeightPercent :: proc(node: Node_Ref, height: f32) ---
        NodeStyleSetHeightAuto :: proc(node: Node_Ref) ---
        NodeStyleSetHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMinWidth :: proc(node: Node_Ref, minWidth: f32) ---
        NodeStyleSetMinWidthPercent :: proc(node: Node_Ref, minWidth: f32) ---
        NodeStyleSetMinWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMinWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMinHeight :: proc(node: Node_Ref, minHeight: f32) ---
        NodeStyleSetMinHeightPercent :: proc(node: Node_Ref, minHeight: f32) ---
        NodeStyleSetMinHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMinHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMinHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMaxWidth :: proc(node: Node_Ref, maxWidth: f32) ---
        NodeStyleSetMaxWidthPercent :: proc(node: Node_Ref, maxWidth: f32) ---
        NodeStyleSetMaxWidthMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxWidthFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxWidthStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMaxWidth :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetMaxHeight :: proc(node: Node_Ref, maxHeight: f32) ---
        NodeStyleSetMaxHeightPercent :: proc(node: Node_Ref, maxHeight: f32) ---
        NodeStyleSetMaxHeightMaxContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxHeightFitContent :: proc(node: Node_Ref) ---
        NodeStyleSetMaxHeightStretch :: proc(node: Node_Ref) ---
        NodeStyleGetMaxHeight :: proc(node: Node_Const_Ref) -> Value ---

        NodeStyleSetAspectRatio :: proc(node: Node_Ref, aspectRatio: f32) ---
        NodeStyleGetAspectRatio :: proc(node: Node_Const_Ref) -> f32 ---

        NodeLayoutGetLeft :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetTop :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetRight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetBottom :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetWidth :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetHeight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetDirection :: proc(node: Node_Const_Ref) -> Direction ---
        NodeLayoutGetHadOverflow :: proc(node: Node_Const_Ref) -> bool ---
        NodeLayoutGetMargin :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetBorder :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetPadding :: proc(node: Node_Const_Ref, edge: Edge) -> f32 ---
        NodeLayoutGetRawHeight :: proc(node: Node_Const_Ref) -> f32 ---
        NodeLayoutGetRawWidth :: proc(node: Node_Const_Ref) -> f32 ---

        RoundValueToPixelGrid :: proc(value, pointScaleFactor: f64, forceCeil, forceFloor: bool) -> f32 ---
    }
}
