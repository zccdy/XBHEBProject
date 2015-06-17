//
//  UIMacroDefine.h
//  XBHEBProject
//
//  Created by xubh-note on 15/4/7.
//  Copyright (c) 2015年 xu banghui. All rights reserved.
//

#ifndef XBHEBProject_UIMacroDefine_h
#define XBHEBProject_UIMacroDefine_h


#define     XBHShareAppDelegate         ((AppDelegate *)[UIApplication sharedApplication].delegate)


#define SOURCE_CELL_HEIGHT              (CELL_ICON_HEIGHT+20)

#define     INPUTFIELDHEIGHT            (44)

#define     XBHLineHeight               (IOS7SYSTEMVERSION_OR_LATER ? 0.5 : 1.0)

#define     XBHSeparatorColor           XBHMakeRGB(69.0, 75.0, 87.0)

#define     XBHLineColor                XBHSeparatorColor             //XBHMakeRGB_SameValue(208)


#define     XBHCornerRadius             (10.0)

#define     XBHAdapterHeight            (IOS7SYSTEMVERSION_OR_LATER ? 0 : 44)

#define     XBHUIThemeColor             XBHMakeRGB(87.0, 93.0, 103.0)

#define     XBHUIPageColor              XBHMakeRGB(125.0, 132.0, 142.0)

#define     XBHScreenHeight             [UIScreen mainScreen].bounds.size.height

#define     XBHButtonColor              XBHMakeRGB(0, 161.0, 217.0)


#define     XBHAppDelegateInstance      ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define     XBHSubcontrollerBackTitle(_title)         self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:_title style:UIBarButtonItemStylePlain target:nil action:nil]



#define     XBHStartActivityWithView(_V)          [XBHAppDelegateInstance startActivityWithView:_V]


#define     XBHStopActivityWithView(_V)           [XBHAppDelegateInstance stopActivityWithView:_V]

#define     DefaultUserId                   (0)

#define     DefaultDataType                 (0)




#define CELL_ICON_OFFSET        (12.5)
#define CELL_TEXT_OFFSET        (12.5)         //图片文字间距

#define CELL_ICON_WIDTH         (26)
#define CELL_ICON_HEIGHT        (29)

#define CELL_FIRST_LINE_FONT            [UIFont boldSystemFontOfSize:13]
#define CELL_SECOND_LINE_FONT           [UIFont systemFontOfSize:9]

#define CELL_TEXT1_COLOR                XBHMakeRGB(255.0, 255.0, 255.0)
#define CELL_TEXT2_COLOR                XBHMakeRGB(255.0, 255.0, 255.0)


#endif
