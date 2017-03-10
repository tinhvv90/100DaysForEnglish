//
//  AlertView.swift
//  AlertView
//
//  Created by Vu Tinh on 1/9/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

// Action Types
public enum ActionType {
    case none, selector, closure
}

// Button sub-class
class Button: UIButton {
    var actionType = ActionType.none
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    var customBackgroundColor:UIColor?
    var customTextColor:UIColor?
    var initialTitle:String!
    var showDurationStatus:Bool=false
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
}

// Pop Up Styles
public enum AlertViewStyle {
    case success,notice//,  error, warning, info, edit, wait, question
    
    var defaultColorInt: UInt32 {
        switch self {
        case .success:
            return 0x22B573
//        case .error:
//            return 0xC1272D
        case .notice:
            return 0x727375
//        case .warning:
//            return 0xFFD110
//        case .info:
//            return 0x2866BF
//        case .edit:
//            return 0xA429FF
//        case .wait:
//            return 0xD62DA5
//        case .question:
//            return 0x727375
        }
        
    }
}

// Animation Styles
public enum AnimationStyle {
    case noAnimation, topToBottom, bottomToTop, leftToRight, rightToLeft
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
class AlertViewResponder {
    let alertview: AlertView
    
    // Initialisation and Title/Subtitle/Close functions
    init(alertview: AlertView) {
        self.alertview = alertview
    }
    
    func setTitle(title: String) {
        self.alertview.labelTitle.text = title
    }
    
    func setSubTitle(subTitle: String) {
        self.alertview.viewText.text = subTitle
    }
    
    func close() {
        self.alertview.hideView()
    }
    
    func setDismissBlock(dismissBlock: DismissBlock) {
        self.alertview.dismissBlock = dismissBlock
    }
}


let kCircleHeightBackground: CGFloat = 62.0

public typealias DismissBlock = () -> Void

class AlertView: UIViewController {

    struct Appearance {
        let kDefaultShadowOpacity : CGFloat
        let kCircleTopPosition : CGFloat
        let kCircleBackgroundTopPosition : CGFloat
        let kCircleHeight : CGFloat
        let kCircleIconHeight : CGFloat
        let kTitleTop : CGFloat
        let kTitleHeight : CGFloat
        let kWindowWidth : CGFloat
        var kWindowHeight : CGFloat
        var kTextHeight : CGFloat
        let kTextFieldHeight : CGFloat
        let kTextViewdHeight : CGFloat
        let kButtonHeight : CGFloat
        let circleBackgroundColor : UIColor
        let contentViewColor : UIColor
        let contentViewBorderColor : UIColor
        let titleColor : UIColor
        
        // Fonts
        let kTitleFont: UIFont
        let kTextFont: UIFont
        let kButtonFont: UIFont
        
        // UI Options
        var disableTapGesture: Bool
        var showCloseButton: Bool
        var showCircularIcon: Bool
        var shouldAutoDismiss: Bool // Set this false to 'Disable' Auto hideView when SCLButton is tapped
        var contentViewCornerRadius : CGFloat
        var fieldCornerRadius : CGFloat
        var buttonCornerRadius : CGFloat
        var dynamicAnimatorActive : Bool
        
        // Actions
        var hideWhenBackgroundViewIsTapped: Bool
        
        init(kDefaultShadowOpacity: CGFloat = 0.7, kCircleTopPosition: CGFloat = 0.0, kCircleBackgroundTopPosition: CGFloat = 6.0, kCircleHeight: CGFloat = 56.0, kCircleIconHeight: CGFloat = 20.0, kTitleTop: CGFloat = 30.0, kTitleHeight: CGFloat = 25.0, kWindowWidth: CGFloat = 240.0, kWindowHeight: CGFloat = 178.0, kTextHeight: CGFloat = 90.0, kTextFieldHeight: CGFloat = 45.0, kTextViewdHeight: CGFloat = 80.0, kButtonHeight: CGFloat = 45.0, kTitleFont: UIFont = UIFont.systemFontOfSize(20), kTextFont: UIFont = UIFont.systemFontOfSize(14), kButtonFont: UIFont = UIFont.boldSystemFontOfSize(14), showCloseButton: Bool = true, showCircularIcon: Bool = true, shouldAutoDismiss: Bool = true, contentViewCornerRadius: CGFloat = 5.0, fieldCornerRadius: CGFloat = 3.0, buttonCornerRadius: CGFloat = 3.0, hideWhenBackgroundViewIsTapped: Bool = false, circleBackgroundColor: UIColor = UIColor.whiteColor(), contentViewColor: UIColor = UIColor.colorFormHex(0xFFFFFF), contentViewBorderColor: UIColor = UIColor.colorFormHex(0xCCCCCC), titleColor: UIColor = UIColor.colorFormHex(0x4D4D4D), dynamicAnimatorActive: Bool = false, disableTapGesture: Bool = false){
            
            self.kDefaultShadowOpacity = kDefaultShadowOpacity
            self.kCircleTopPosition = kCircleTopPosition
            self.kCircleBackgroundTopPosition = kCircleBackgroundTopPosition
            self.kCircleHeight = kCircleHeight
            self.kCircleIconHeight = kCircleIconHeight
            self.kTitleTop = kTitleTop
            self.kTitleHeight = kTitleHeight
            self.kWindowWidth = kWindowWidth
            self.kWindowHeight = kWindowHeight
            self.kTextHeight = kTextHeight
            self.kTextFieldHeight = kTextFieldHeight
            self.kTextViewdHeight = kTextViewdHeight
            self.kButtonHeight = kButtonHeight
            
            self.kTitleFont = kTitleFont
            self.kTextFont = kTextFont
            self.kButtonFont = kButtonFont
            
            self.showCloseButton = showCloseButton
            self.showCircularIcon = showCircularIcon
            self.shouldAutoDismiss = shouldAutoDismiss
            
            self.contentViewCornerRadius = contentViewCornerRadius
            self.fieldCornerRadius = fieldCornerRadius
            self.buttonCornerRadius = buttonCornerRadius
            
            self.hideWhenBackgroundViewIsTapped = hideWhenBackgroundViewIsTapped
            
            self.circleBackgroundColor = circleBackgroundColor
            self.contentViewColor = contentViewColor
            self.contentViewBorderColor = contentViewBorderColor
            self.titleColor = titleColor
            self.dynamicAnimatorActive = dynamicAnimatorActive
            self.disableTapGesture = disableTapGesture
        }
        
        mutating func setkWindowHeight(kWindowHeight:CGFloat) {
            self.kWindowHeight = kWindowHeight
        }
        
        mutating func setkTextHeight(kTextHeight:CGFloat) {
            self.kTextHeight = kTextHeight
        }
    }
    
    var appearance: Appearance!
    
    // UI Colour
    var viewColor = UIColor()
    
    // UI Options
    var iconTintColor: UIColor?
    var customSubview: UIView?
    
    // Members declaration
    var baseView = UIView()
    var labelTitle = UILabel()
    var viewText = UITextView()
    var contentView = UIView()
    var circleBG = UIView(frame: CGRect(x: 0, y: 0, width: kCircleHeightBackground, height: kCircleHeightBackground))
    var circleView = UIView()
    var circleIconView: UIView?
    var duration: NSTimeInterval!
    var durationStatusTimer: NSTimer!
    var durationTimer: NSTimer?
    var dismissBlock: DismissBlock?
    
    private var inputs = [UITextField]()
    private var input = [UITextView]()
    internal var buttons = [Button]()
    private var selfReference: AlertView?
    
    var tmpContentViewFrameOrigin: CGPoint?
    var tmpCircleViewFrameOrigin: CGPoint?
    var keyboardHasBeenShown:Bool = false
    
    init(appearance: Appearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        appearance = Appearance()
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        // Set up main view
        view.frame = UIScreen.mainScreen().bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: appearance.kDefaultShadowOpacity)
        view.addSubview(baseView)
        
        // Base View
        baseView.frame = view.frame
        baseView.addSubview(contentView)
        // Content View
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(labelTitle)
        contentView.addSubview(viewText)
        // Circle View
        circleBG.backgroundColor = appearance.circleBackgroundColor
        circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
        baseView.addSubview(circleBG)
        circleBG.layer.masksToBounds = true
        circleBG.addSubview(circleView)
        let x = (kCircleHeightBackground - appearance.kCircleHeight) / 2
        circleView.frame = CGRect(x: x, y: x + appearance.kCircleTopPosition, width: appearance.kCircleHeight, height: appearance.kCircleHeight)
        circleView.layer.cornerRadius = circleView.frame.height / 2
        // Title
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .Center
        labelTitle.font = appearance.kTitleFont
        labelTitle.frame = CGRect(x:12, y:appearance.kTitleTop, width: appearance.kWindowWidth - 24, height:appearance.kTitleHeight)
        // View text
        viewText.editable = false
        viewText.textAlignment = .Center
        viewText.textContainerInset = UIEdgeInsetsZero
        viewText.textContainer.lineFragmentPadding = 0
        viewText.font = appearance.kTextFont
        // Colours
        contentView.backgroundColor = appearance.contentViewColor
        viewText.backgroundColor = appearance.contentViewColor
        labelTitle.textColor = appearance.titleColor
        viewText.textColor = appearance.titleColor
        contentView.layer.borderColor = appearance.contentViewBorderColor.CGColor
        //Gesture Recognizer for tapping outside the textinput
        if appearance.disableTapGesture == false {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        let sz = rv.frame.size
        // Set background frame
        view.frame.size = sz
        
        let hMargin: CGFloat = 12
        
        // get actual height of title text
        var titleActualHeight: CGFloat = 0
        if let title = labelTitle.text {
            titleActualHeight = title.heightWithConstrainedWidth(appearance.kWindowWidth - hMargin * 2, font: labelTitle.font) + 10
            // get the larger height for the title text
            titleActualHeight = (titleActualHeight > appearance.kTitleHeight ? titleActualHeight : appearance.kTitleHeight)
        }
        
        // computing the right size to use for the textView
        let maxHeight = sz.height - 100 // max overall height
        var consumedHeight = CGFloat(0)
        consumedHeight += (titleActualHeight > 0 ? appearance.kTitleTop + titleActualHeight : hMargin)
        consumedHeight += 14
        consumedHeight += appearance.kButtonHeight * CGFloat(buttons.count)
        consumedHeight += appearance.kTextFieldHeight * CGFloat(inputs.count)
        consumedHeight += appearance.kTextViewdHeight * CGFloat(input.count)
        let maxViewTextHeight = maxHeight - consumedHeight
        let viewTextWidth = appearance.kWindowWidth - hMargin * 2
        var viewTextHeight = appearance.kTextHeight
        
        // Check if there is a custom subview and add it over the textview
        if let customSubview = customSubview {
            viewTextHeight = min(customSubview.frame.height, maxViewTextHeight)
            viewText.text = ""
            viewText.addSubview(customSubview)
        } else {
            // computing the right size to use for the textView
            let suggestedViewTextSize = viewText.sizeThatFits(CGSize(width: viewTextWidth, height: CGFloat.max))
            viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)
            
            // scroll management
            if (suggestedViewTextSize.height > maxViewTextHeight) {
                viewText.scrollEnabled = true
            } else {
                viewText.scrollEnabled = false
            }
        }
        
        let windowHeight = consumedHeight + viewTextHeight
        // Set frames
        var x = (sz.width - appearance.kWindowWidth) / 2
        var y = (sz.height - windowHeight - (appearance.kCircleHeight / 8)) / 2
        contentView.frame = CGRect(x:x, y:y, width:appearance.kWindowWidth, height:windowHeight)
        contentView.layer.cornerRadius = appearance.contentViewCornerRadius
        y -= kCircleHeightBackground * 0.6
        x = (sz.width - kCircleHeightBackground) / 2
        circleBG.frame = CGRect(x:x, y:y+appearance.kCircleBackgroundTopPosition, width:kCircleHeightBackground, height:kCircleHeightBackground)
        
        //adjust Title frame based on circularIcon show/hide flag
        let titleOffset : CGFloat = appearance.showCircularIcon ? 0.0 : -12.0
        labelTitle.frame = labelTitle.frame.offsetBy(dx: 0, dy: titleOffset)
        
        // Subtitle
        y = titleActualHeight > 0 ? appearance.kTitleTop + titleActualHeight + titleOffset : hMargin
        viewText.frame = CGRect(x:hMargin, y:y, width: appearance.kWindowWidth - hMargin * 2, height:appearance.kTextHeight)
        viewText.frame = CGRect(x:hMargin, y:y, width: viewTextWidth, height:viewTextHeight)
        // Text fields
        y += viewTextHeight + 14.0
        for txt in inputs {
            txt.frame = CGRect(x:hMargin, y:y, width:appearance.kWindowWidth - hMargin * 2, height:30)
            txt.layer.cornerRadius = appearance.fieldCornerRadius
            y += appearance.kTextFieldHeight
        }
        for txt in input {
            txt.frame = CGRect(x:hMargin, y:y, width:appearance.kWindowWidth - hMargin * 2, height:70)
            //txt.layer.cornerRadius = fieldCornerRadius
            y += appearance.kTextViewdHeight
        }
        // Buttons
        for btn in buttons {
            btn.frame = CGRect(x:hMargin, y:y, width:appearance.kWindowWidth - hMargin * 2, height:35)
            btn.layer.cornerRadius = appearance.buttonCornerRadius
            y += appearance.kButtonHeight
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if event?.touchesForView(view)?.count > 0 {
            view.endEditing(true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        keyboardHasBeenShown = true
        
        guard let userInfo = (notification as NSNotification).userInfo else {return}
        guard let endKeyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().minY else {return}
        
        if tmpContentViewFrameOrigin == nil {
            tmpContentViewFrameOrigin = self.contentView.frame.origin
        }
        
        if tmpCircleViewFrameOrigin == nil {
            tmpCircleViewFrameOrigin = self.circleBG.frame.origin
        }
        
        var newContentViewFrameY = self.contentView.frame.maxY - endKeyBoardFrame
        if newContentViewFrameY < 0 {
            newContentViewFrameY = 0
        }
        let newBallViewFrameY = self.circleBG.frame.origin.y - newContentViewFrameY
        self.contentView.frame.origin.y -= newContentViewFrameY
        self.circleBG.frame.origin.y = newBallViewFrameY
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(keyboardHasBeenShown){//This could happen on the simulator (keyboard will be hidden)
            if(self.tmpContentViewFrameOrigin != nil){
                self.contentView.frame.origin.y = self.tmpContentViewFrameOrigin!.y
                self.tmpContentViewFrameOrigin = nil
            }
            if(self.tmpCircleViewFrameOrigin != nil){
                self.circleBG.frame.origin.y = self.tmpCircleViewFrameOrigin!.y
                self.tmpCircleViewFrameOrigin = nil
            }
            
            keyboardHasBeenShown = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Dismiss keyboard when tapped outside textfield & close SCLAlertView when hideWhenBackgroundViewIsTapped
    func tapped(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if let tappedView = gestureRecognizer.view where
            tappedView.hitTest(gestureRecognizer.locationInView(tappedView), withEvent: nil) == baseView && appearance.hideWhenBackgroundViewIsTapped {
            hideView()
        }
        
    }

    func hideView() {
        NSNotificationCenter.defaultCenter().postNotificationName(reloadMapData, object: nil)
        UIView.animateWithDuration(0.2, animations: { 
            self.view.alpha = 0
            }) { (finished) in
                //Stop durationTimer so alertView does not attempt to hide itself and fire it's dimiss block a second time when close button is tapped
                self.durationTimer?.invalidate()
                // Stop StatusTimer
                self.durationStatusTimer?.invalidate()
                
                if (self.dismissBlock != nil) {
                    // Call completion handler when the alert is dismissed
                    self.dismissBlock!()
                }
                
                // This is necessary for SCLAlertView to be de-initialized, preventing a strong reference cycle with the viewcontroller calling SCLAlertView.
                for button in self.buttons {
                    button.action = nil
                    button.target = nil
                    button.selector = nil
                }
                
                self.view.removeFromSuperview()
                self.selfReference = nil
        }
    }
    
    func addTextField(title:String? = "") -> UITextField {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextFieldHeight)
        // Add text field
        let txt = UITextField()
        txt.borderStyle = UITextBorderStyle.RoundedRect
        txt.font = appearance.kTextFont
        txt.autocapitalizationType = UITextAutocapitalizationType.Words
        txt.clearButtonMode = UITextFieldViewMode.WhileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        if title != nil {
            txt.placeholder = title!
        }
        contentView.addSubview(txt)
        inputs.append(txt)
        return txt
    }
    
    func addTextView() -> UITextView {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kTextViewdHeight)
        // Add text view
        let txt = UITextView()
        // No placeholder with UITextView but you can use KMPlaceholderTextView library
        txt.font = appearance.kTextFont
        //txt.autocapitalizationType = UITextAutocapitalizationType.Words
        //txt.clearButtonMode = UITextFieldViewMode.WhileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        contentView.addSubview(txt)
        input.append(txt)
        return txt
    }
    
    func addButton(title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showDurationStatus: Bool = false, action: Selector ) -> Button {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus,action: action)
        btn.actionType = ActionType.closure
        btn.addTarget(self, action: #selector(buttonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        btn.addTarget(self, action:#selector(buttonTapDown), forControlEvents:[UIControlEvents.TouchDown, UIControlEvents.TouchDragEnter])
        btn.addTarget(self, action:#selector(buttonRelease), forControlEvents:[UIControlEvents.TouchUpInside, UIControlEvents.TouchUpOutside, UIControlEvents.TouchCancel, UIControlEvents.TouchDragOutside] )
        return btn
    }
    
    func addButton(title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showDurationStatus: Bool = false, target: AnyObject, selector: Selector) -> Button {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = ActionType.selector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action:#selector(buttonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        btn.addTarget(self, action:#selector(buttonTapDown), forControlEvents:[UIControlEvents.TouchDown, UIControlEvents.TouchDragEnter])
        btn.addTarget(self, action:#selector(buttonRelease), forControlEvents:[UIControlEvents.TouchUpInside, .TouchUpOutside, .TouchCancel, .TouchDragOutside] )
        return btn
    }
    
    private func addButton(title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, showDurationStatus: Bool = false) -> Button {
        // Update view height
        appearance.setkWindowHeight(appearance.kWindowHeight + appearance.kButtonHeight)
        // Add button
        let btn = Button()
        btn.layer.masksToBounds = true
        btn.setTitle(title, forState: UIControlState())
        btn.titleLabel?.font = appearance.kButtonFont
        btn.customBackgroundColor = backgroundColor
        btn.customTextColor = textColor
        btn.initialTitle = title
        btn.showDurationStatus = showDurationStatus
        contentView.addSubview(btn)
        buttons.append(btn)
        return btn
    }
    
    func buttonTapped(btn: Button) {
        if btn.actionType == ActionType.closure {
            btn.action()
        } else if btn.actionType == ActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to: btn.target, forEvent: nil)
        } else {
            print("Unknow action type for button")
        }
        
        if (self.view.alpha != 0.0 && appearance.shouldAutoDismiss) {
            hideView()
        }
    }
    
    func buttonTapDown(btn: Button) {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        let pressBrightnessFactor = 0.85
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness * CGFloat(pressBrightnessFactor)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func buttonRelease(btn: Button) {
        btn.backgroundColor = btn.customBackgroundColor ?? viewColor
    }
    
    // showCustom(view, title, subTitle, UIColor, UIImage)
    func showCustom(title: String, subTitle: String, color: UIColor, icon: UIImage, closeButtonTitle: String? = nil, duration: NSTimeInterval = 0.0, colorStyle: UInt32 = AlertViewStyle.success.defaultColorInt, colorTextButton: UInt32 = 0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: AnimationStyle = .topToBottom) -> AlertViewResponder {
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(red * 255.0) << 16
        colorAsUInt32 += UInt32(green * 255.0) << 8
        colorAsUInt32 += UInt32(blue * 255.0)
        
        let colorAsUInt = colorAsUInt32
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .success, colorStyle: colorAsUInt, colorTextButton: colorTextButton, circleIconImage: icon, animationStyle: animationStyle)

    }
    
    func showTitle(title: String, subTitle: String, duration: NSTimeInterval?, completeText: String?, style: AlertViewStyle, colorStyle: UInt32? = 0x000000, colorTextButton: UInt32?=0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: AnimationStyle = .topToBottom) -> AlertViewResponder {
        
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        let colorInt = colorStyle ?? style.defaultColorInt
        viewColor = UIColor.colorFormHex(colorInt)
        // Icon style
        switch style {
        case .success:
            iconImage = checkCircleIconImage(circleIconImage, defaultImage: AlertViewStyleKit.imageOfCheckmark)
        case .notice:
            iconImage = checkCircleIconImage(circleIconImage, defaultImage: AlertViewStyleKit.imageOfNotice)
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
            let actualHeight = title.heightWithConstrainedWidth(appearance.kWindowWidth - 24, font: self.labelTitle.font)
            self.labelTitle.frame = CGRect(x:12, y:appearance.kTitleTop, width: appearance.kWindowWidth - 24, height:actualHeight)
        }

        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSFontAttributeName:viewText.font ?? UIFont()]
            let sz = CGSize(width: appearance.kWindowWidth - 24, height:90)
            let r = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < appearance.kTextHeight {
                appearance.kWindowHeight -= (appearance.kTextHeight - ht)
                appearance.setkTextHeight(ht)
            }
        }
        
        // Done button
        if appearance.showCloseButton {
//            _ = addButton(completeText ?? "Done", target:self, selector:#selector(AlertView.hideView))
            _ = addButton(completeText ?? "Done", target: self, selector: #selector(AlertView.hideView))
        }
        
        //hidden/show circular view based on the ui option
        circleView.hidden = !appearance.showCircularIcon
        circleBG.hidden = !appearance.showCircularIcon
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor

        // Spinner / icon
        if let iconTintColor = iconTintColor {
            circleIconView = UIImageView(image: iconImage!.imageWithRenderingMode(.AlwaysTemplate))
            circleIconView?.tintColor = iconTintColor
        } else {
            circleIconView = UIImageView(image: iconImage!)
        }
        
        circleView.addSubview(circleIconView!)
        let x = (appearance.kCircleHeight - appearance.kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x, y: x, width: appearance.kCircleIconHeight, height: appearance.kCircleIconHeight)
        circleIconView?.layer.cornerRadius = circleIconView!.bounds.height / 2
        circleIconView?.layer.masksToBounds = true

        for txt in inputs {
            txt.layer.borderColor = viewColor.CGColor
        }
        
        for txt in input {
            txt.layer.borderColor = viewColor.CGColor
        }
        
        for btn in buttons {
            if let customBackgroundColor = btn.customBackgroundColor {
                // Custom BackgroundColor set
                btn.backgroundColor = customBackgroundColor
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.backgroundColor = viewColor
            }
            
            if let customTextColor = btn.customTextColor {
                // Custom TextColor set
                btn.setTitleColor(customTextColor, forState:UIControlState())
            } else {
                // Use default BackgroundColor derived from AlertStyle
                btn.setTitleColor(UIColor.colorFormHex(colorTextButton ?? 0xFFFFFF), forState:UIControlState())
            }
        }
        
        // Adding duration
        if duration > 0 {
            self.duration = duration
            durationTimer?.invalidate()
            durationTimer = NSTimer.scheduledTimerWithTimeInterval(self.duration, target: self, selector: #selector(AlertView.hideView), userInfo: nil, repeats: false)
            durationStatusTimer?.invalidate()
            durationStatusTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(AlertView.updateDurationStatus), userInfo: nil, repeats: true)
        }
        
        // Animate in the alert view
        self.showAnimation(animationStyle)
        // Chainable objects
        return AlertViewResponder(alertview: self)
    }

    // Show animation in the alert view
    private func showAnimation(animationStyle: AnimationStyle = .topToBottom, animationStartOffset: CGFloat = -400.0, boundingAnimationOffset: CGFloat = 15.0, animationDuration: NSTimeInterval = 0.2) {
        
        let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
        var animationStartOrigin = self.baseView.frame.origin
        var animationCenter : CGPoint = rv.center
        
        switch animationStyle {
        case .noAnimation:
            self.view.alpha = 1.0
            return;
        case .topToBottom:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y + animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y + boundingAnimationOffset)
        case .bottomToTop:
            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y - animationStartOffset)
            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - boundingAnimationOffset)
        case .leftToRight:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x + animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x + boundingAnimationOffset, y: animationCenter.y)
        case .rightToLeft:
            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x - animationStartOffset, y: animationStartOrigin.y)
            animationCenter = CGPoint(x: animationCenter.x - boundingAnimationOffset, y: animationCenter.y)
        }
        
        self.baseView.frame.origin = animationStartOrigin
        
        if self.appearance.dynamicAnimatorActive {
            UIView.animateWithDuration(animationDuration, animations: { 
                self.view.alpha = 1.0
            })
            self.animate(self.baseView, center: rv.center)
        } else {
            UIView.animateWithDuration(animationDuration, animations: { 
                self.view.alpha = 1.0
                self.baseView.center = animationCenter
                }, completion: { (finished) in
                    UIView.animateWithDuration(animationDuration, animations: { 
                        self.view.alpha = 1.0
                        self.baseView.center = rv.center
                    })
            })
        }
    }
    
    // DynamicAnimator function
    var animator : UIDynamicAnimator?
    var snapBehavior : UISnapBehavior?
    
    private func animate(item : UIView , center: CGPoint) {
        if let snapBehavior = self.snapBehavior {
            self.animator?.removeBehavior(snapBehavior)
        }
        self.animator = UIDynamicAnimator.init(referenceView: self.view)
        let tempSnapBehavior  =  UISnapBehavior.init(item: item, snapToPoint: center)
        self.animator?.addBehavior(tempSnapBehavior)
        self.snapBehavior? = tempSnapBehavior
    }
    
    func updateDurationStatus() {
        duration = duration.advancedBy(-1)
        for btn in buttons.filter({$0.showDurationStatus}) {
            let txt = String(btn.initialTitle) + " " + String(Int(duration))
            btn.setTitle(txt, forState: UIControlState())
        }
    }
    
    func checkCircleIconImage(circleIconImage: UIImage?, defaultImage: UIImage) -> UIImage {
        if let image = circleIconImage {
            return image
        } else {
            return defaultImage
        }
    }
    
    // showNotice(view, title, subTitle)
    func showNotice(title: String, subTitle: String, closeButtonTitle:String? = nil, duration: NSTimeInterval = 0.0, colorStyle: UInt32 = AlertViewStyle.notice.defaultColorInt, colorTextButton: UInt32 = 0xFFFFFF, circleIconImage: UIImage? = nil, animationStyle: AnimationStyle = .topToBottom) -> AlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .notice, colorStyle: colorStyle, colorTextButton: colorTextButton, circleIconImage: circleIconImage, animationStyle: animationStyle)
    }
    
}

// ------------------------------------
// Icon drawing
// Code generated by PaintCode
// ------------------------------------

class AlertViewStyleKit : NSObject {
    // Cache
    
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var checkmarkTargets: [AnyObject]?
        static var imageOfCross: UIImage?
        static var crossTargets: [AnyObject]?
        static var imageOfNotice: UIImage?
        static var noticeTargets: [AnyObject]?
        static var imageOfWarning: UIImage?
        static var warningTargets: [AnyObject]?
        static var imageOfInfo: UIImage?
        static var infoTargets: [AnyObject]?
        static var imageOfEdit: UIImage?
        static var editTargets: [AnyObject]?
        static var imageOfQuestion: UIImage?
        static var questionTargets: [AnyObject]?
    }
    
    // Initialization
    /// swift 1.2 abolish func load
    //    override class func load() {
    //    }
    
    // Drawing Methods
    class func drawCheckmark() {
        // Checkmark Shape Drawing
        let checkmarkShapePath = UIBezierPath()
        checkmarkShapePath.moveToPoint(CGPoint(x: 73.25, y: 14.05))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 64.51, y: 13.86), controlPoint1: CGPoint(x: 70.98, y: 11.44), controlPoint2: CGPoint(x: 66.78, y: 11.26))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 27.46, y: 52))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 15.75, y: 39.54))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 6.84, y: 39.54), controlPoint1: CGPoint(x: 13.48, y: 36.93), controlPoint2: CGPoint(x: 9.28, y: 36.93))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 6.84, y: 49.02), controlPoint1: CGPoint(x: 4.39, y: 42.14), controlPoint2: CGPoint(x: 4.39, y: 46.42))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 6.84, y: 49.02), controlPoint1: CGPoint(x: 4.39, y: 42.14), controlPoint2: CGPoint(x: 4.39, y: 46.42))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 22.91, y: 66.14))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 27.28, y: 68), controlPoint1: CGPoint(x: 24.14, y: 67.44), controlPoint2: CGPoint(x: 25.71, y: 68))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 31.65, y: 66.14), controlPoint1: CGPoint(x: 28.86, y: 68), controlPoint2: CGPoint(x: 30.43, y: 67.26))
        checkmarkShapePath.addLineToPoint(CGPoint(x: 73.08, y: 23.35))
        checkmarkShapePath.addCurveToPoint(CGPoint(x: 73.25, y: 14.05), controlPoint1: CGPoint(x: 75.52, y: 20.75), controlPoint2: CGPoint(x: 75.7, y: 16.65))
        checkmarkShapePath.closePath()
        checkmarkShapePath.miterLimit = 4
        UIColor.whiteColor().setFill()
        checkmarkShapePath.fill()
    }
    
    class func drawNotice() {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()
        noticeShapePath.moveToPoint(CGPoint(x: 72, y: 48.54))
        noticeShapePath.addLineToPoint(CGPoint(x: 72, y: 39.9))
        noticeShapePath.addCurveToPoint(CGPoint(x: 66.38, y: 34.01), controlPoint1: CGPoint(x: 72, y: 36.76), controlPoint2: CGPoint(x: 69.48, y: 34.01))
        noticeShapePath.addCurveToPoint(CGPoint(x: 61.53, y: 35.97), controlPoint1: CGPoint(x: 64.82, y: 34.01), controlPoint2: CGPoint(x: 62.69, y: 34.8))
        noticeShapePath.addCurveToPoint(CGPoint(x: 60.36, y: 35.78), controlPoint1: CGPoint(x: 61.33, y: 35.97), controlPoint2: CGPoint(x: 62.3, y: 35.78))
        noticeShapePath.addLineToPoint(CGPoint(x: 60.36, y: 33.22))
        noticeShapePath.addCurveToPoint(CGPoint(x: 54.16, y: 26.16), controlPoint1: CGPoint(x: 60.36, y: 29.3), controlPoint2: CGPoint(x: 57.65, y: 26.16))
        noticeShapePath.addCurveToPoint(CGPoint(x: 48.73, y: 29.89), controlPoint1: CGPoint(x: 51.64, y: 26.16), controlPoint2: CGPoint(x: 50.67, y: 27.73))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.73, y: 28.71))
        noticeShapePath.addCurveToPoint(CGPoint(x: 43.49, y: 21.64), controlPoint1: CGPoint(x: 48.73, y: 24.78), controlPoint2: CGPoint(x: 46.98, y: 21.64))
        noticeShapePath.addCurveToPoint(CGPoint(x: 39.03, y: 25.37), controlPoint1: CGPoint(x: 40.97, y: 21.64), controlPoint2: CGPoint(x: 39.03, y: 23.01))
        noticeShapePath.addLineToPoint(CGPoint(x: 39.03, y: 9.07))
        noticeShapePath.addCurveToPoint(CGPoint(x: 32.24, y: 2), controlPoint1: CGPoint(x: 39.03, y: 5.14), controlPoint2: CGPoint(x: 35.73, y: 2))
        noticeShapePath.addCurveToPoint(CGPoint(x: 25.45, y: 9.07), controlPoint1: CGPoint(x: 28.56, y: 2), controlPoint2: CGPoint(x: 25.45, y: 5.14))
        noticeShapePath.addLineToPoint(CGPoint(x: 25.45, y: 41.47))
        noticeShapePath.addCurveToPoint(CGPoint(x: 24.29, y: 43.44), controlPoint1: CGPoint(x: 25.45, y: 42.45), controlPoint2: CGPoint(x: 24.68, y: 43.04))
        noticeShapePath.addCurveToPoint(CGPoint(x: 9.55, y: 43.04), controlPoint1: CGPoint(x: 16.73, y: 40.88), controlPoint2: CGPoint(x: 11.88, y: 40.69))
        noticeShapePath.addCurveToPoint(CGPoint(x: 8, y: 46.58), controlPoint1: CGPoint(x: 8.58, y: 43.83), controlPoint2: CGPoint(x: 8, y: 45.2))
        noticeShapePath.addCurveToPoint(CGPoint(x: 14.4, y: 55.81), controlPoint1: CGPoint(x: 8.19, y: 50.31), controlPoint2: CGPoint(x: 12.07, y: 53.84))
        noticeShapePath.addLineToPoint(CGPoint(x: 27.2, y: 69.56))
        noticeShapePath.addCurveToPoint(CGPoint(x: 42.91, y: 77.8), controlPoint1: CGPoint(x: 30.5, y: 74.47), controlPoint2: CGPoint(x: 35.73, y: 77.21))
        noticeShapePath.addCurveToPoint(CGPoint(x: 43.88, y: 77.8), controlPoint1: CGPoint(x: 43.3, y: 77.8), controlPoint2: CGPoint(x: 43.68, y: 77.8))
        noticeShapePath.addCurveToPoint(CGPoint(x: 47.18, y: 78), controlPoint1: CGPoint(x: 45.04, y: 77.8), controlPoint2: CGPoint(x: 46.01, y: 78))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.34, y: 78))
        noticeShapePath.addLineToPoint(CGPoint(x: 48.34, y: 78))
        noticeShapePath.addCurveToPoint(CGPoint(x: 71.61, y: 52.08), controlPoint1: CGPoint(x: 56.48, y: 78), controlPoint2: CGPoint(x: 69.87, y: 75.05))
        noticeShapePath.addCurveToPoint(CGPoint(x: 72, y: 48.54), controlPoint1: CGPoint(x: 71.81, y: 51.29), controlPoint2: CGPoint(x: 72, y: 49.72))
        noticeShapePath.closePath()
        noticeShapePath.miterLimit = 4
        
        UIColor.whiteColor().setFill()
        noticeShapePath.fill()
    }
    
    // Generated Images
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        AlertViewStyleKit.drawCheckmark()
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    class var imageOfNotice: UIImage {
        if (Cache.imageOfNotice != nil) {
            return Cache.imageOfNotice!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        AlertViewStyleKit.drawNotice()
        Cache.imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfNotice!
    }
}

let reloadMapData = "reloadMapData"
