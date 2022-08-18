//
//  MessageCell.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-23.
//

//customising cells in a TableView using a .xib file
import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//to make the messageBuble UIView to have some rounded corners
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 2
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
