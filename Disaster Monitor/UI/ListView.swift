import UIKit
import Tempura
import PinLayout

class ListView: UIView, ViewControllerModellableView {
  
  // MARK: - Subviews
  var scrollView: UIScrollView = UIScrollView()
  var todoListView: CollectionView<AttractionCell, SimpleSource<AttractionCellViewModel>>!
  // the view of the child view controller
  var childViewContainer: ContainerView = ContainerView()
  
  // MARK: - Interactions
  
  // MARK: - Setup
  func setup() {
    self.scrollView.isPagingEnabled = true
    self.scrollView.isScrollEnabled = false
    self.todoListView = CollectionView<AttractionCell, SimpleSource<AttractionCellViewModel>>(frame: .zero, layout: todoLayout)
    self.todoListView.useDiffs = true
    
    self.scrollView.addSubview(self.todoListView)
    self.addSubview(self.childViewContainer)
  }
  
  // MARK: - Style
  func style() {
    self.backgroundColor = .white
    self.styleTodoListView()
  }
  
  // MARK: - Update
  func update(oldModel: ListViewModel?) {
    guard let model = self.model, oldModel != self.model else { return }
  }
  
  // MARK: - Layout
  override func layoutSubviews() {
    // we are using PinLayout here but you can use the layout system you want
    self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width * 2, height: self.scrollView.bounds.height)
    self.todoListView.frame = self.scrollView.frame.bounds
    guard let model = self.model else { return }

    self.childViewContainer.pin.bottom().left().right().height(80)
  }
}

// MARK: - Styling
extension ListView {
  func styleTodoListView() {
    self.todoListView.backgroundColor = .white
  }
}

// MARK: - View Model
struct ListViewModel: ViewModelWithLocalState, Equatable {
  var todos: [Event]
  
  init?(state: AppState?, localState: ListLocalState) {

  }
  
  static func == (l: ListViewModel, r: ListViewModel) -> Bool {

  }
}

// MARK: - List sections
extension ListView {
  enum Section {
    case todo
    case archived
  }
}
