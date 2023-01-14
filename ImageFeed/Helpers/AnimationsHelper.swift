import UIKit

class AnimationsHelper  {
    var gradient: CAGradientLayer
    var gradient2: CAGradientLayer
    var gradient3: CAGradientLayer
    var gradient4: CAGradientLayer
    var gradient5: CAGradientLayer

    init() {
//        self.addAnimations()
        self.gradient = CAGradientLayer()
        self.gradient2 = CAGradientLayer()
        self.gradient3 = CAGradientLayer()
        self.gradient4 = CAGradientLayer()
        self.gradient5 = CAGradientLayer()
    }

    func addAnimations() {
        // градиент аватарки
//        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
//        profileImageView.layer.addSublayer(gradient)

        // градиент имени
//        let gradient2 = CAGradientLayer()
        gradient2.frame = CGRect(origin: .zero, size: CGSize(width: 223, height: 28))
        gradient2.locations = [0, 0.1, 0.3]
        gradient2.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient2.startPoint = CGPoint(x: 0, y: 0.5)
        gradient2.endPoint = CGPoint(x: 1, y: 0.5)
        gradient2.cornerRadius = 14
        gradient2.masksToBounds = true
//        nameLabel.layer.addSublayer(gradient2)

        // градиент никнейма
//        let gradient3 = CAGradientLayer()
        gradient3.frame = CGRect(origin: .zero, size: CGSize(width: 89, height: 18))
        gradient3.locations = [0, 0.1, 0.3]
        gradient3.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient3.startPoint = CGPoint(x: 0, y: 0.5)
        gradient3.endPoint = CGPoint(x: 1, y: 0.5)
        gradient3.cornerRadius = 9
        gradient3.masksToBounds = true
//        nicknameLabel.layer.addSublayer(gradient3)

        // градиент сообщения
//        let gradient4 = CAGradientLayer()
        gradient4.frame = CGRect(origin: .zero, size: CGSize(width: 67, height: 18))
        gradient4.locations = [0, 0.1, 0.3]
        gradient4.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient4.startPoint = CGPoint(x: 0, y: 0.5)
        gradient4.endPoint = CGPoint(x: 1, y: 0.5)
        gradient4.cornerRadius = 9
        gradient4.masksToBounds = true
//        messageLabel.layer.addSublayer(gradient4)

        //запускаем анимацию градиента аватара
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]

        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        gradient2.add(gradientChangeAnimation, forKey: "locationsChange")
        gradient3.add(gradientChangeAnimation, forKey: "locationsChange")
        gradient4.add(gradientChangeAnimation, forKey: "locationsChange")

//        self.gradient = gradient
//        self.gradient2 = gradient2
//        self.gradient3 = gradient3
//        self.gradient4 = gradient4
//        return {gradient, gradient2, gradient, gradient4}
    }

    func removeAvatarAnimations(){
        print("______removeAvatarAnimations")
        gradient.removeFromSuperlayer()

    }
    func removeTextAnimations(){
        print("____removeTextAnimations")
        gradient2.removeFromSuperlayer()
        gradient3.removeFromSuperlayer()
        gradient4.removeFromSuperlayer()
    }

    func addImagesListAnimations(){
        // градиент в ленте
//        let gradient = CAGradientLayer()
        gradient5.frame = CGRect(origin: .zero, size: CGSize(width: 343, height: 370))
        gradient5.locations = [0, 0.1, 0.3]
        gradient5.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient5.startPoint = CGPoint(x: 0, y: 0.5)
        gradient5.endPoint = CGPoint(x: 1, y: 0.5)
        gradient5.cornerRadius = 16
        gradient5.masksToBounds = true
//        cell.cellImage.layer.addSublayer(gradient)

        //запускаем анимацию градиента в ленте
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient5.add(gradientChangeAnimation, forKey: "locationsChange")
    }

    func removeImagesListAnimations(){
        print("_______removeImagesListAnimations")
        gradient5.removeFromSuperlayer()
    }


}
