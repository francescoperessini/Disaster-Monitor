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
    let list = [["Terremoto Scandinavia", "Magnitudo: 9 AreeColpite: A B C", "1.2"],["Terremoto Bresso", "Magnitudo: 9 AreeColpite: A B C", "1.4"],["Terremoto Puglia", "Magnitudo: 9 AreeColpite: A B C", "0.9"],["Terremoto Puglia", "Magnitudo: 9 AreeColpite: A B C", "0.9"],["Terremoto Puglia", "Magnitudo: 9 AreeColpite: A B C", "0.9"],["Terremoto Puglia", "Magnitudo: 9 AreeColpite: A B C", "0.9"],["Terremoto Puglia", "Magnitudo: 9 AreeColpite: A B C", "0.9"],]
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
        self.scrollView.pin.all()
        self.eventsListView.frame = self.scrollView.frame.bounds
    }
    
    func update(oldModel: ListViewModel?) {
        guard let model = self.model else { return }
        let events = model.list.map { EventCellViewModel(identifier: $0[0], description: $0[1], magnitudo: $0[2]) }
        self.eventsListView.source = SimpleSource<EventCellViewModel>(events)
        
        self.setNeedsLayout()
    }
        
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        // TODO: change source of attractionListView
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
}

