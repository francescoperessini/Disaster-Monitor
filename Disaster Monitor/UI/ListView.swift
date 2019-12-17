//
//  ListView.swift
//
//
//  Created on 28/11/2019
//

import UIKit
import Tempura
import PinLayout

struct ListViewModel: ViewModel, Equatable {
    let num = 0
    let list = ["ciao1","ciao2","ciao3","ciao4","ciao5"]
}


class ListView: UIView, ModellableView {
    var scrollView = UIScrollView()
    var eventsListView: CollectionView<EventCell, SimpleSource<EventCellViewModel>>!
    
    // MARK: - Interactions
    var animate: Interaction?
        
    func setup() {
        self.scrollView.isPagingEnabled = true
        self.scrollView.isScrollEnabled = false
        let eventsLayout = EventsFlowLayout()
        self.eventsListView = CollectionView<EventCell, SimpleSource<EventCellViewModel>>(frame: .zero, layout: eventsLayout)
        self.eventsListView.useDiffs = true

        self.scrollView.addSubview(self.eventsListView)
        self.addSubview(self.scrollView)
    }
    
    func style() {
        self.backgroundColor = .systemBackground
        self.eventsListView.backgroundColor = .systemBackground
        self.scrollView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.pin.top(pin.safeArea).left(pin.safeArea).width(100)
        self.eventsListView.frame = self.scrollView.frame.bounds
    }
    
    func update(oldModel: ListViewModel?) {
        guard let model = self.model else { return }
        let attractions = model.list.map { EventCellViewModel(identifier: $0) }
        self.eventsListView.source = SimpleSource<EventCellViewModel>(attractions)
        self.setNeedsLayout()
    }
        
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        // TODO: change source of attractionListView
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
}

