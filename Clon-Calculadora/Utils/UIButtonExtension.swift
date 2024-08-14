
import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton{
    
    // Redondear bordes
    func round(){
        layer.cornerRadius = bounds.height / 2
        clipsToBounds =  true
    }
    
    // Brillar botón
    func shine (){
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }){ (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    func selectOperation (_ selected: Bool){
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal)
        tintColor = selected ? orange : .white
    }
    
}
