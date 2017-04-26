//
//  FloatingActionButton.swift
//  SwiftYell
//
//  Created by abe-riki on 2016/11/24.
//  Copyright © 2016年 abe-riki. All rights reserved.
//

import UIKit


class FloatingActionButton: UIButton {
	
	// 要素ボタンのリスト
	private var buttonList = [UIButton]()
	// ボタン押下時のアクションリスト
	private var buttonTapActionList = [()->Void]()
	
	// FABが展開されているか否かのフラグ
	private var isShow:Bool = false
	
	private var grayView:UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
		
		return view
	}()
	
	/// 要素のボタン生成
	///
	/// - Parameters:
	///   - title: タイトル
	///   - textColor: テキスト色(デフォは白)
	///   - font: フォント(デフォはシステムで17pt)
	///   - image: 画像
	///   - action: ボタン押した時のアクション
	func addElement(title:String, textColor:UIColor = UIColor.white, font:UIFont = UIFont.systemFont(ofSize: 17) ,image:UIImage, action:@escaping ()->()) {
		
		// 展開されるボタンの生成
		let button = UIButton(type: .custom)
		button.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: image.size.width, height: image.size.height)
		button.setImage(image, for: .normal)
		button.setTitle(title, for: .normal)
		button.titleLabel?.textColor = textColor
		button.titleLabel?.font = font
		button.titleLabel?.sizeToFit()
		if let titlesize = button.titleLabel?.frame.size {
			var frame = button.frame
			frame.size.width += titlesize.width
			button.frame = frame
			// 画像とテキストの位置調整
			button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(button.frame.size.width - titlesize.width), 0.0, 0.0);
			button.imageEdgeInsets = UIEdgeInsetsMake(0.0, button.frame.size.width - image.size.width, 0.0, 0.0);
			// 左詰め
			button.contentHorizontalAlignment = .left;
			frame.origin.x -= titlesize.width
			button.frame = frame
			button.layoutIfNeeded()
		}
		button.addTarget(self, action: #selector(tapbutton(_:)), for: .touchUpInside)
		button.isHidden = true
		button.isExclusiveTouch = true
		self.buttonTapActionList.append(action)
		button.tag = self.buttonList.count + 1
		if let superView = self.superview {
			superView.addSubview(button)
			
			superView.layoutIfNeeded()
			
			self.buttonList.append(button)
		}
	}
	
	/// メインボタン開く
	func openMainButton() {
		
		if self.isShow {
			return
		}
		
		// メインボタン回転
		self.layer.transform = CATransform3DMakeRotation(CGFloat(.pi / 180.0) * 45.0, 0.0, 0.0, 1)
		
		// ボタンとスーパービューの間にグレイビューを貼る
		if let superView = self.superview {

			superView.insertSubview(self.grayView, belowSubview: self)
			
			// AutoLayoutの設定
			let constraintTop = NSLayoutConstraint(item: self.grayView,
			                                       attribute: .top,
			                                       relatedBy: .equal,
			                                       toItem: superView,
			                                       attribute: .top,
			                                       multiplier: 1.0,
			                                       constant: 0.0)
			let constraintButtom = NSLayoutConstraint(item: self.grayView,
			                                          attribute: .bottom,
			                                          relatedBy: .equal,
			                                          toItem: superView,
			                                          attribute: .bottom,
			                                          multiplier: 1.0,
			                                          constant: 0.0)
			let constraintLeading = NSLayoutConstraint(item: self.grayView,
			                                           attribute: .leading,
			                                           relatedBy: .equal,
			                                           toItem: superView,
			                                           attribute: .leading,
			                                           multiplier: 1.0,
			                                           constant: 0.0)
			let constraintTrailing = NSLayoutConstraint(item: self.grayView,
			                                            attribute: .trailing,
			                                            relatedBy: .equal,
			                                            toItem: superView,
			                                            attribute: .trailing,
			                                            multiplier: 1.0,
			                                            constant: 0.0)
			
			superView.addConstraints([constraintTop, constraintButtom, constraintLeading, constraintTrailing])
		}
		
		var originY:CGFloat = self.frame.origin.y
		for button in self.buttonList {
			button.isHidden = false
			UIView.animate(withDuration: 0.2) {
				var frame = button.frame
				frame.origin.y = originY - (button.frame.size.height + 10.0)
				button.frame = frame
				originY = button.frame.origin.y
				print(Thread.current);
			}
		}
		self.isShow = true
	}
	
	
	/// メインボタン閉じる
	func closeMainButton(competion:(()->())?) {
		
		if !self.isShow {
			return
		}
		
		// メインボタン初期状態に戻す
		self.layer.transform = CATransform3DIdentity
		
		for button in self.buttonList {
			UIView.animate(withDuration: 0.2, animations: {
				var frame = button.frame
				frame.origin.y = self.frame.origin.y
				button.frame = frame
			}, completion: { (true) in
				button.isHidden = true
				if(button == self.buttonList.last) {
					self.grayView.removeFromSuperview()
					if let competion = competion {
						competion()
					}
					
				}
			})
		}
		self.isShow = false
	}
	
	
	
// MARK: - private関数

	/// 各要素のボタン押下時のアクション
	///
	/// - Parameter button: 各要素のボタン
	@objc private func tapbutton(_ button:UIButton) {
		self.closeMainButton(competion: {
			self.buttonTapActionList[button.tag - 1]()
		})
	}
	
	
	/// 自ボタン押下時のアクション
	///
	/// - Parameter button: 自ボタン
	@objc private func tapMainButton(_ button:UIButton) {
		
		if !self.isShow {
			self.openMainButton()
		} else {
			self.closeMainButton(competion: nil)
		}
	}
	
// MARK: - ライフサイクル
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		self.addTarget(self, action: #selector(tapMainButton(_:)), for: .touchUpInside)
	}

}
