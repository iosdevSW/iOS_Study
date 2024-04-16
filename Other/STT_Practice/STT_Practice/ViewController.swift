//
//  ViewController.swift
//  STT_Practice
//
//  Created by SangWoo's MacBook on 2022/07/03.
//
/* 1. Info에서 Privacy - Microphone Usage Description
              Privacy - Speech Recognition Usage Descrition
    를 추가하여 마이크와 Sppech 권한 허가
 */
import UIKit
import Speech

class ViewController: UIViewController {
   
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR")) // 한국말 Recognizer 생성
    
    //음성인식요청을 처리하는 객체
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    //음성 인식 요청 결과를 제공하는 객체
    private var recognitionTast: SFSpeechRecognitionTask?
    // 소리를 인식하는 오디오 엔진 객체
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechRecognizer?.delegate = self //대리자 지정
        
    }

    @IBAction func clickedBtn(_ sender: Any) {
        if self.audioEngine.isRunning { // 현재 음성인식이 수행중이면
            self.audioEngine.stop() // 오디오 인식 중지
            self.recognitionRequest?.endAudio() // 음성인식도 중지
            self.button.isEnabled = false
            self.button.setTitle("시작", for: .normal)
        }else { //현재 음성인식이 수행중이지 않으면
            self.startRecoding() // 음성인식 시작
            button.setTitle("종료", for: .normal)
        }
    }
    
    
    
}

extension ViewController: SFSpeechRecognizerDelegate {
    func startRecoding(){
        //인식 작업이 실행중이라면 중단
        if self.recognitionTast != nil {
            self.recognitionTast?.cancel()
            self.recognitionTast = nil
        }
        //오디오 녹음을 준비할 객체 ( 단순히 정말 소리만 인식하는 객체임)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            // 세션을 녹음 범주 , 측정 모드 , 활성화 설정
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch(let e) { //오류 처리
            print(e.localizedDescription)
        }
        // 음성인식을 요청하는 객체 생성
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 오디오 입력할 장치가 있는지 확인
        let inputNode = self.audioEngine.inputNode
        
        guard let recognitionRequest = self.recognitionRequest else {
            fatalError("No Request Instance")
            return
        }
        //말할 때 부분적인 결과를 보고하도록 함
        recognitionRequest.shouldReportPartialResults = true
        //음성 인식중에 세련되거나,최소 정지 한 때에 결과를 반환해주는 Handler
        self.recognitionTast = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                //결과가 nil이 아니면 변환된 텍스트 반환
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)! //최종이면 true 중간결과면 false
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTast = nil
                self.button.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
               
        self.audioEngine.prepare()
               
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
               
        self.textView.text = "Say something, I'm listening!"
    }
    
    
}


class Test: Equatable {
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.num == rhs.num
    }
    
    public static func != (lhs: Test, rhs: Test) -> Bool {
        return lhs.num != rhs.num
    }
    
    var num: Int
    
    init(_ num: Int) {
        self.num = num
    }
}



