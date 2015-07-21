
import Foundation
import UIKit


enum ASTimePickerFormat : Int {
  case FormatFull = 0 //  HH : MM : SS
  case FormatNormal   //  HH : MM
  case FormatSingle   //  HH
}

private let HOUR_TAG = 0
private let MINUTE_TAG = 1
private let SECOND_TAG = 2
private let kTimeCellIndentifier = "TimeCell"
private let kMaxTimeCount = 59
private let kHourLength = 24
private let kMinuteLength = 60

// *************************************************************************
// MARK: - ASPickerView

public class ASPickerView: UIControl {
  
  /// private properties
  private var cellHeight: CGFloat!
  private var hourTableView: NumberPickerTableView!
  private var minuteTableView: NumberPickerTableView!
  private var secondTableView: NumberPickerTableView!
  private var componentTables: [UITableView]?
  
  
  var delegate: ASPickerViewDelegate?
  
  /// the picker font property. Default font size -> system font 16
  var pickerFont: UIFont = UIFont.systemFontOfSize(16)
  
  /// the picker format type property. Default is full -> HH:MM:SS
  var pickerFormat: ASTimePickerFormat = .FormatFull
  
  /// the custom view for center picker separator
  var separatorView: UIView!
  var padding:CGFloat = 5.0
  var separatorColor = UIColor ( red: 0.4038, green: 0.94, blue: 0.991, alpha: 1.0 )
  
  var currentHour = 0, currentMinute = 0, currentSecond = 0
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.whiteColor()
    
    self.viewInit()
    self.setDefaults()
  }

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func viewInit() {
    
    cellHeight = self.frame.size.height/7
    
    // Add gradoent mask on top and bottom picker
    var topGradient = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2))
    var gradientMaskTop = CAGradientLayer()
    gradientMaskTop.frame = self.bounds
    gradientMaskTop.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
    gradientMaskTop.locations = [0.0, 0.5, 0.5, 0.5, 1.0]
    self.layer.mask = gradientMaskTop
    
    layoutView()
  }
  
  func setDefaults() {
    
  }
  
  func layoutView() {
    
    componentTables?.removeAll(keepCapacity: false)
    
    var collCount = 0
    switch pickerFormat {
    case .FormatFull:
      collCount = 2
    case .FormatNormal:
      collCount = 1
    default:
      collCount = 0
    }
    
    var index = 0
    var collWidth = CGRectGetWidth(self.frame)/CGFloat(collCount + 1) - padding*CGFloat(collCount)
    if collWidth > 40 {
      collWidth = 40
    }
    var startX = (CGRectGetWidth(self.frame) - (collWidth + padding)*CGFloat(collCount + 1))/2
    
    for _ in 0...collCount {
      
      var x0 = startX + collWidth*CGFloat(index) + padding*CGFloat(index)
      
      separatorView = UIView(frame: CGRectMake(x0 + 3, (self.frame.size.height - cellHeight)/2, collWidth - 6, cellHeight))
      separatorView.backgroundColor = separatorColor
      separatorView.layer.cornerRadius = collWidth/2 - 10
      separatorView.clipsToBounds = true
      self.addSubview(separatorView!)
      
      let tFrame = CGRectMake(x0, 0, collWidth, CGRectGetHeight(self.frame))
      var tableView = NumberPickerTableView(frame: tFrame, style: UITableViewStyle.Plain)
      tableView.contentInset = UIEdgeInsetsMake((CGRectGetHeight(tableView.frame) - cellHeight)/2, 0, (CGRectGetHeight(tableView.frame) - cellHeight)/2, 0);
      
      tableView.registerClass(DateFilterCell.self, forCellReuseIdentifier: kTimeCellIndentifier)
      tableView.delegate = self
      tableView.dataSource = self
      tableView.tag = index
      println("DecelerationRate \(tableView.decelerationRate)")
      // Hacking scroll decleration rate on UITableView to slowly
      tableView.decelerationRate = 0.2
      self.addSubview(tableView)
      
      if index < collCount {
        var separator = UILabel(frame: CGRectMake(tFrame.origin.x + CGRectGetWidth(tFrame), (CGRectGetHeight(self.frame) - 30)/2, padding, 30))
        separator.textAlignment = NSTextAlignment.Center
        separator.textColor = separatorColor
        separator.font = UIFont.systemFontOfSize(21)
        separator.text = ":"
        self.addSubview(separator)
      }
      
      componentTables?.append(tableView)
      index++
    }
  }
}

func refreshTables() {
  
}

// *************************************************************************
// MARK: - UIScrollView Delegate and Additional Methods

extension ASPickerView: UIScrollViewDelegate {
  
  public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    if let tableView = scrollView as? UITableView {
      if let indexPath = tableView.indexPathForSelectedRow() {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
      }
    }
  }
  
  public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    var targetOffsetY = targetContentOffset.memory.y
    var adjustedOffsetY = round(targetOffsetY/cellHeight)*cellHeight

    scrollView.setContentOffset(CGPointMake(targetContentOffset.memory.x, adjustedOffsetY), animated: true)
  }
  
  public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      selectMiddleRowOnScreenForTableView(scrollView)
    }
  }
  
  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    selectMiddleRowOnScreenForTableView(scrollView)

    var targetOffsetY = scrollView.contentOffset.y
    var adjustedOffsetY = round(targetOffsetY/cellHeight)*cellHeight
    scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x, adjustedOffsetY), animated: true)
  }
  
  public func selectMiddleRowOnScreenForTableView(scrollView: UIScrollView) {
    var index = getIndexForScrollViewPosition(scrollView)
    
    if let tableView = scrollView as? UITableView {
      tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
      
      // Keep time index when tableview is selected
      switch tableView.tag {
      case MINUTE_TAG:
        currentMinute = index
      case SECOND_TAG:
        currentSecond = index
      default:
        currentHour = index
      }
      
      self.delegate?.datePickerDidChange(currentHour, minute: currentMinute, second: currentSecond)
    }
  }

  public func scrollToAndSelectIndex(index: NSInteger, tableView: UITableView) {
    var indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
    tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
  }
  
  public func getIndexForScrollViewPosition(scrollView: UIScrollView) -> NSInteger {
    var offsetContentScrollView = (scrollView.frame.size.height - cellHeight) / 2.0;
    var offsetY = scrollView.contentOffset.y;
    var index = roundf(Float((offsetY + offsetContentScrollView)/cellHeight))
    return NSInteger(index);
  }
}

// *************************************************************************
// MARK: - UITableView DataSource & Delegate

extension ASPickerView: UITableViewDelegate {
  
}

extension ASPickerView: UITableViewDataSource {

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch tableView.tag {
    case HOUR_TAG:
      return kHourLength
    case MINUTE_TAG:
      return kMinuteLength
    case SECOND_TAG:
      return kMinuteLength
    default:
        return kHourLength
    }
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    var cell:DateFilterCell = tableView.dequeueReusableCellWithIdentifier(kTimeCellIndentifier) as! DateFilterCell
    
    cell.textFont = pickerFont
    cell.label.text = "\(indexPath.row)"
    cell.userInteractionEnabled = false
    
    return cell
  }
  
  public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    // TODO implement animation show cell appeart
//    var cellContentView = cell
//    var rotationAngleRadians = -90 * (M_PI/180)
//    var offsetPositioning = CGPointMake(10, 0)
//    
//    var transform = CATransform3DIdentity
//    transform = CATransform3DRotate(transform, CGFloat(rotationAngleRadians), CGFloat(-50.0), CGFloat(0), CGFloat(1.0))
//    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, CGFloat(-50.0));
//    
//    cellContentView.layer.transform = transform;
//    cellContentView.layer.opacity = 0.8;
//    
//    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
//      cellContentView.layer.transform = CATransform3DIdentity
//      cellContentView.layer.opacity = 1
//      }, completion: { finished in
//
//    })
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
}

// *************************************************************************
// MARK: - DateFilterCell

class DateFilterCell: UITableViewCell {
  
  var textFont: UIFont!
  var label: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyle.None
    self.contentView.backgroundColor = UIColor.clearColor()
    self.backgroundColor = UIColor.clearColor()
    label = UILabel(frame: self.bounds)
    label.backgroundColor = UIColor.clearColor()
    label.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    label.textAlignment = NSTextAlignment.Center
    self.addSubview(label)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      label.font = textFont.fontWithSize(textFont.pointSize + 7)
      label.textColor = UIColor.whiteColor()
    } else {
      label.font = textFont
      label.textColor = UIColor.blackColor()
    }
  }
}


// *************************************************************************
// MARK: - NumberPickerTableView

class NumberPickerTableView: UITableView {
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    
    self.backgroundColor = UIColor.clearColor();
    self.showsVerticalScrollIndicator = false
    self.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}