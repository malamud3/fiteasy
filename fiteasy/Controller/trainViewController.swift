//
//  trainViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 1/07/2022.
//

import UIKit
import AVFoundation

class trainViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var set: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    var trainerData = Trainer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //indexs
    var index=0
    var setIndex=0
    var status=0 //0=start 1=Train 3=EndTrain
    
    //timer
    var trainTimer = Timer()
    var secRemaining=10
    
    //check end
    var end=false
    
    //audio
        var player: AVAudioPlayer!
        var endRest = SoundPlayer(soundName: "endRest", type: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.confingView(cardView)
      //  Utilities.confingImg(img)
        title = "Training Time"
        initView()

    }
    
    
    @IBAction func btn_press(_ sender: UIButton) {
        self.start_btn.isHidden = true
        
        if(status==0){
          startUpdate()
        }
        else if(status==1){
        trainingUpdate()
        }
       else if(status==2){
            
        }
        
        
    }
    
    func playSound(sound:SoundPlayer?){
        let url = Bundle.main.url(forResource: sound?.soundName, withExtension: sound?.type)
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }

    func initView(){
        initIndex()
        updateUI()
    }
    
    func initIndex(){
        while(trainerData.TrainPlan?.exercises[index].weight == ""){
                index+=1
        }
    }
    func startUpdate(){
        trainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate) , userInfo: nil, repeats: true)
        updateBtnUI()
        nextSet()
        status=1
    }
    
    func trainingUpdate(){
        if(isExEnded() == false){
            setRestTime(restType:0)
            nextSet()
        }else{
            moveIndex()
            if(end == false){
                setRestTime(restType:1)
                restSet()
            }else{
                //end
                self.performSegue(withIdentifier: K.endTrain, sender: self)
            }
     
        }
        trainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate) , userInfo: nil, repeats: true)
        updateBtnUI()
        updateUI()
    }
    
    func nextSet(){
        setIndex+=1
        set.text = "\(setIndex)/\(trainerData.TrainPlan?.exercises[index].sets ?? "3")"
    }
    func restSet(){
        setIndex=0
        set.text = "\(setIndex)/\(trainerData.TrainPlan?.exercises[index].sets ?? "3")"
    }
    func isExEnded()->Bool{
        if(setIndex<Int(trainerData.TrainPlan?.exercises[index].sets ?? "0") ?? 0){
            return false
        }else{
            return true
        }
    }
    
    
    
    
    @objc func timerUpdate(){
        if secRemaining>0 {
            secRemaining-=1
            timer.text = "time left: \(secRemaining)"
            if(secRemaining==3){
                playSound(sound: endRest)
            }
        }else{
            trainTimer.invalidate()
        }
    }
     
    func updateBtnUI(){
        self.start_btn.setTitle("Next", for: .normal)
        self.start_btn.isHidden = false

    }
    
    func setRestTime(restType:Int){
        if restType == 0{
            secRemaining=trainerData.TrainPlan?.exercises[index].restBetweenSets ?? 60
        }else{
            secRemaining=5
        }
        
    }
    
    func updateUI(){
        updateText()
        updateImg()
    }
    
    func updateText(){
        weight.text=trainerData.TrainPlan?.exercises[index].weight
        reps.text=trainerData.TrainPlan?.exercises[index].reps
        set.text="\(setIndex)/\(trainerData.TrainPlan?.exercises[index].sets ?? "3")"
        name.text=trainerData.TrainPlan?.exercises[index].name
    }
    
    func updateImg(){
        UIView.transition(with: img, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
        img.loadFrom(URLAddress: trainerData.TrainPlan?.exercises[index].imgUrl ?? "")
    }
    
    //what ex to start
    func moveIndex(){
        // next is ok
        if (trainerData.TrainPlan?.exercises[index+1].restBetweenSets != nil){
            index+=1
        }
        //check if next
        else{
            while(trainerData.TrainPlan?.exercises[index+1].weight == ""){
                if(index+1==(trainerData.TrainPlan?.exercises.count)!-1){
                    end=true
                    break
                }else{
                    index+=1
                }
            }
        }

    }


    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
