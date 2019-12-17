//
//  AttractionCell.swift
//  SmartTourist
//
//  Created on 30/11/2019
//

import Foundation
import UIKit
import Tempura
import PinLayout
import DeepDiff

public protocol SizeableCell: ModellableView {
  static func size(for model: VM) -> CGSize
}

// MARK: View Model
struct EventCellViewModel: ViewModel {
    let identifier: String
    
    static func == (l: EventCellViewModel, r: EventCellViewModel) -> Bool {
        if l.identifier != r.identifier {return false}
        return true
    }
}


// MARK: - View
class EventCell: UICollectionViewCell, ConfigurableCell, SizeableCell {
    static func size(for model: EventCellViewModel) -> CGSize { //MAGIC FUNCTION
        //let textWidth = UIScreen.main.bounds.width * AttractionCell.maxTextWidth
        //let textHeight = model.attractionName.height(constraintedWidth: textWidth, font: font)
        let textHeight: CGFloat = 42
        return CGSize(width: UIScreen.main.bounds.width,
                      height: textHeight + 2)
    }
    
    static var identifierForReuse: String = "EventCell"
    
    //MARK: Subviews
    var nameLabel = UILabel()
    var image = UIImageView(image: UIImage(systemName: "chevron.right"))
    var distanceLabel = UILabel()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setup() {
        self.distanceLabel.textAlignment = .right
        self.addSubview(self.nameLabel)
        self.addSubview(self.image)
        self.addSubview(self.distanceLabel)
    }
    
    //MARK: Style
    func style() {
        
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        self.nameLabel.pin.center()
    }
    
    //MARK: Update
    func update(oldModel: EventCellViewModel?) {
        guard let model = self.model else {return}
        nameLabel.text = model.identifier
    }
}



// MARK: - DiffAware conformance
extension EventCellViewModel: DiffAware {
    var diffId: Int { return self.identifier.hashValue }

    static func compareContent(_ a: EventCellViewModel, _ b: EventCellViewModel) -> Bool {
        return a.identifier == b.identifier
    }
}
