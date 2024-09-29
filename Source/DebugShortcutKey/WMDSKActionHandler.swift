//
//  WMDSKActionHandler.swift
//  PerfectDebug
//
//  Created by SonG on 2022/12/21.
//

import UIKit

@_cdecl("wmdsk_handlePress")
public func c_wmdsk_handlePress(presses: Set<UIPress>, responder: UIResponder) -> Bool {
    return WMDSKActionHandler.handlePress(presses: presses, responder: responder)
}

@objc internal protocol WMDSKey_Internal {
    @objc optional dynamic var _userDefineAction: ((_ target: UIResponder?) -> Void)? { get }
}
@objc extension WMDSKey: WMDSKey_Internal {}
 
fileprivate class WMDSKActionHandler {
    
    /// 处理键盘事件
    static func handlePress(presses: Set<UIPress>, responder: UIResponder) -> Bool {
        if tryHandleBuildInShortcut(presses: presses, responder: responder) {
            //  是SDK内置快捷键
            return true
        }
        
        /*
         检查该快捷键是否有响应者
         快捷键可能会同时出现多个响应者, 比如在 TableView 中的 Cell 中
         */
        var responderSet = Set<WMDSKey>()
        tryHandleCustomShortcut(presses: presses, responder: responder, responderSet: &responderSet)
        
        //  A. 没有人响应这个快捷键
        guard responderSet.isEmpty == false else {
            return false
        }
        
        //  B. 有人能响应快捷键
        let responders = Array(responderSet)
        
        //  B.A 只有一个响应者, 模拟点击事件
        if responders.count == 1, let singleKey = responders.first {
            //  用户自定义Block
            if let _userDefineAction = (singleKey as WMDSKey_Internal)._userDefineAction, let _userDefineAction {
                _userDefineAction(singleKey.responder)
            }
            //  UIControl
            else if let controlResp = singleKey.responder as? UIControl {
                controlResp.allTargets.forEach { target in
                    //  只处理 TouchUpInside
                    controlResp.actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach({ action in
                        UIApplication.shared.sendAction(NSSelectorFromString(action), to: target, from: controlResp, for: nil)
                    })
                }
            }
            //  UIView
            else if let viewResp = singleKey.responder as? UIView {
                viewResp.gestureRecognizers?.filter({ $0 is UITapGestureRecognizer }).forEach({ gesture in
                    
                })
            }
            //  未知的情况, 丢弃
            else {
                print("[WMDebugShortcutKey] 不知道如何处理 \(String(describing: singleKey.responder)) 的响应!")
            }
        }
        //  B.B 多个响应者, 用户需要进一步选择响应快捷键的是谁
        else {
            assertionFailure("待完成")
        }
        
        return responders.isEmpty == false
    }

    ///  检查是否是SDK内置事件, 比如 ESC 退出 Controller
    static private func tryHandleBuildInShortcut(presses: Set<UIPress>, responder: UIResponder) -> Bool {
        guard let vc = responder as? UIViewController else {
            return false
        }
        
        //  预置的 Esc 事件, 退出当前页面
        if presses.first?.key?.keyCode == .keyboardEscape {
            //  如果有 NavigationController, 交给 NavigationController 处理
            if let navvc = vc.navigationController {
                return tryHandleBuildInShortcut(presses: presses, responder: navvc)
            }
            
            let topVC = UIViewController.wmdsk_topViewController
            
            //  一般情况下, 只有 UINavigationController 处理 Esc 事件
            if let navvc = vc as? UINavigationController, topVC?.navigationController == vc {
                //  先检查是否需要Pop
                if navvc.children.count > 1 {
                    navvc.popViewController(animated: true)
                    return true
                }
                //  再检查是否需要Dismiss
                else if navvc.presentingViewController != nil {
                    navvc.dismiss(animated: true)
                    return true
                }
            }
            //  如果没 UINavigationController, 那直接判断 vc 是否需要 dismiss
            else if vc.navigationController == nil,
                    vc.presentingViewController != nil,
                    topVC == vc {
                vc.dismiss(animated: true)
                return true
            }
        }
    
        return false
    }
    
    ///  检查能否响应自定义事件
    static private func tryHandleCustomShortcut(presses: Set<UIPress>, responder: UIResponder, responderSet: inout Set<WMDSKey>) {
        //  1. 这个 Responder 能否响应这个快捷键?
        if responder.wmdsk_isAvailable,
           let keyValue = presses.first?.key?.keyCode.rawValue,
           let keyCode = WMDSKKeyType(rawValue: UInt(keyValue)),
           responder.responds(to: NSSelectorFromString("wm_debugShortcutKeys")) {
            
            responder.wm_debugShortcutKeys().filter {
                $0.keyType == keyCode && ($0.responder?.wmdsk_isAvailable == true)
            }.forEach {
                responderSet.insert($0)
            }
        }
        
        //  2. 他的孩子能否响应?
        if let vc = responder as? UIViewController, vc.wmdsk_isAvailable {
            (vc.children + [vc.view]).forEach {
                tryHandleCustomShortcut(presses: presses, responder: $0, responderSet: &responderSet)
            }
        } else if let view = responder as? UIView, view.wmdsk_isAvailable {
            view.subviews.forEach {
                tryHandleCustomShortcut(presses: presses, responder: $0, responderSet: &responderSet)
            }
        }
    }
}

// MARK: - Private Extensions
fileprivate extension UIResponder {
    ///  当前响应者是否可响应事件
    var wmdsk_isAvailable: Bool {
        if let vc = self as? UIViewController {
            return vc.view.wmdsk_isVisiable
        } else if let view = self as? UIView {
            return view.wmdsk_isVisiable
        }
        
        return false
    }
}

fileprivate extension UIView {
    ///  当前view是否可见
    var wmdsk_isVisiable: Bool {
        isHidden == false
        && alpha >= 0.01
        && window != nil
        && convert(frame, from: nil).size.equalTo(.zero) == false
    }
}

fileprivate extension UIViewController {
    static var wmdsk_topViewController: UIViewController? {
        wmdsk_topViewController(root: UIApplication.shared.keyWindow?.rootViewController)
    }

    static func wmdsk_topViewController(root: UIViewController?) -> UIViewController? {
        if let tabBarController = root as? UITabBarController {
            return wmdsk_topViewController(root: tabBarController.selectedViewController)
        }
        else if let navigationController = root as? UINavigationController {
            return wmdsk_topViewController(root: navigationController.visibleViewController)
        }
        else if let presentedViewController = root?.presentedViewController {
            return wmdsk_topViewController(root: presentedViewController)
        }
        else {
            return root
        }
    }
}
