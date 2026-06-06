import UIKit

class ChatCell: UITableViewCell {
    
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bubbleLeading: NSLayoutConstraint?
    var bubbleTrailing: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
        ])
        
        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
        ])
    }
    
    func configure(text: String, isUser: Bool) {
        messageLabel.text = text
        
        if isUser {
            bubbleView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            bubbleLeading?.isActive = false
            bubbleTrailing?.isActive = true
        } else {
            bubbleView.backgroundColor = UIColor.systemGray5
            messageLabel.textColor = .black
            bubbleTrailing?.isActive = false
            bubbleLeading?.isActive = true
        }
    }
}
