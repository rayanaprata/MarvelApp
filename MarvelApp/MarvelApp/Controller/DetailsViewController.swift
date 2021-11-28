//
//  DetailsViewController.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: Properties
    var characterTouch: CustomData
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    fileprivate let imageDetail: ImageWithBlur = {
        let imageDetail = ImageWithBlur()
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        imageDetail.contentMode = .scaleAspectFill
        imageDetail.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor,
                                UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientLayer.frame = imageDetail.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 10
        imageDetail.layer.insertSublayer(gradientLayer, at: 0)
        
        return imageDetail
    }()
    
    fileprivate lazy var labelName: UILabel = {
        let labelName = UILabel(frame: .zero)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.font = UIFont(name: "Helvetica-Bold", size: 28.0)
        labelName.textColor = .white
        return labelName
    }()
    
    fileprivate lazy var labelBiography: UILabel = {
        let labelBiography = UILabel()
        labelBiography.translatesAutoresizingMaskIntoConstraints = false
        labelBiography.text = """
        Natasha Romanoff was born in the Soviet Union as Natalia Alianovna Romanova (Наталия Альяновна Романова). Although her exact parentage is unknown, it is rumored that she is related to the late Romanov dynasty—the former rulers of Russia—but those claims have so far been unproven. Orphaned as a child, she was rescued during an attack on Stalingrad by a man named Ivan Petrovitch Bezukhov, who looked after and trained the girl.

        As she grew older, Natasha’s talents caught the attention of Soviet Intelligence, soon to be known as the KGB, and was recruited into their ranks. During World War II, Natasha was kidnapped by the Hand, who sought to make her a brainwashed master assassin. Luckily, she was rescued by Steve Rogers (Captain America) and Logan (who would later become Wolverine). During the War, the young Natasha served in the Russian army where she fell in love with another young soldier named Nikolai.

         Despite their initial happiness, their union did not end blissfully. Nikolai was killed in the war and the baby girl they conceived did not survive birth.
        Following World War II, Natasha progressed into the Black Widow Program, where young girls like her were conditioned to become sleeper agents. Trained at a facility called the Red Room, Natasha was also enhanced with the Soviets’ version of the Super-Soldier serum, gifting her with peak human strength and stamina, as well as resistance to disease and slowed-down aging. Natasha has memories of studying to be a ballerina as a cover during this time. However, because her psyche was tampered with by the government, it is unclear if she actually was ever a ballerina, or these memories were implanted.

        As her Black Widow training progressed, she encountered (and romanced) Captain America’s former best friend and sidekick, James Buchanan Barnes, who had been brainwashed into the becoming the assassin known as the Winter Soldier. Their relationship didn’t last long as she was set up to marry Alexei Shostakov, a renowned test pilot. Though they had a happy marriage, the KGB faked his death during an experimental rocket test in order to make him into the Red Guardian, the USSR’s version of Captain America, a hero who would represent and defend the nation.

        Natasha’s grief over his death drove her further into the clutches and control of the Red Room Academy and she finally earned the title of Black Widow.
        Although she initially worked against the Avengers and United States on the behest of her superiors, Natasha ended up defecting to join S.H.I.E.L.D. and later the Avengers to become a true Super Hero.
        """
        labelBiography.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        labelBiography.font = UIFont(name: "Helvetica", size: 16.0)
        labelBiography.textColor = .white
        labelBiography.numberOfLines = 0
        return labelBiography
    }()
    
    fileprivate lazy var labelBiographyTitle: UILabel = {
        let labelBiographyTitle = UILabel(frame: .zero)
        labelBiographyTitle.translatesAutoresizingMaskIntoConstraints = false
        labelBiographyTitle.text = "BIOGRAPHY"
        labelBiographyTitle.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        labelBiographyTitle.textColor = .white
        return labelBiographyTitle
    }()
    
    // MARK: Initialization
    init(_ character: CustomData) {
        self.characterTouch = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Methods    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "marvel-logo.png")
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer

        labelName.text = characterTouch.title
        imageDetail.image = characterTouch.image
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(labelName)
        contentView.addSubview(imageDetail)
        contentView.addSubview(labelBiographyTitle)
        contentView.addSubview(labelBiography)
        
        setupConstraints()
    }
    
    func applyBlur(frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.8).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 10
        imageDetail.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Setting Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageDetail.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageDetail.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            labelName.topAnchor.constraint(equalTo: imageDetail.bottomAnchor, constant: 30),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            
            labelBiographyTitle.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 35),
            labelBiographyTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            labelBiography.topAnchor.constraint(equalTo: labelBiographyTitle.bottomAnchor, constant: 10),
            labelBiography.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            labelBiography.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            labelBiography.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
