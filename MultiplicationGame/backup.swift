//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Alison Gorman on 1/27/21.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var readyToPlay = false
    @Published var questionRandom : [Question] = []
    @Published var tableChoices = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var numberChosen = 0
    @Published var questionArray : [Question] = []
    
    func start() {
        questionArray.removeAll()
        questionRandom.removeAll()
        //get all possible questions
        for i in 0...11 {
            for j in 1...12 {
                if tableChoices[i] == 1 {
                    questionArray.append(Question(first: i+1, second: j))
                }
            }
        }
        //get chosen amount of questions
        var n = 0
        switch numberChosen{
            case 3: n = questionArray.count //all
            case 0: n = 5
            case 1: n = 10
            case 2: n = 20
            default: n = 5
            }
        for _ in 1...n {
            let randomIndex = Int(arc4random_uniform(UInt32(questionArray.count)))
            let q = questionArray.remove(at: randomIndex)
            questionRandom.append(q)
            }
    }
}

struct Question: Hashable {
    var first: Int
    var second: Int
    
    var answer: Int {
        first * second
    }
}

struct MotherView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Group {
            if !userSettings.readyToPlay {
               SettingsView()
            } else {
                GameView()
            }
        }
    }
}


struct GameView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var answer = ""
    @State private var count = 0
    @State private var score = 0
    
    var body: some View {
        Form {
            VStack (spacing: 20) {
            
                if count < userSettings.questionRandom.count {
                    HStack (spacing: 20) {
                        Text("\(userSettings.questionRandom[count].first) * \(userSettings.questionRandom[count].second) = ")
                            .font(.largeTitle)
                        TextField("answer", text: $answer, onCommit:checkAnswer)
                            .font(.largeTitle)
                        //.keyboardType(.numberPad)
                        }
                    //Text( (Int(answer) == userSettings.questionRandom[count].answer) ? "✅" : "❌")
                    }
                
                if count == userSettings.questionRandom.count {
                    Text("Your Score: \(score) / \(count)")
                }
                
                HStack{
                    if count == userSettings.questionRandom.count {
                        Spacer()
                        Button(action: {
                            userSettings.start()
                            count = 0
                            score = 0
                        }){
                            Text("Quiz Again")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            userSettings.readyToPlay = false
                        }){
                            Text("Settings")
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    func checkAnswer() {
        if (Int(answer) == userSettings.questionRandom[count].answer) {
            score += 1
        }
        answer = ""
        count += 1
    }
}


struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State var numberOfQuestion = 0
    let numberOfQuestions = ["5", "10", "20", "All"]
    
    private var fourColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
                VStack(spacing: 20) {
                        Text("Do You Even Multiply?")
                            .font(.largeTitle)
                        Text("Test your Multiplication Skills!")
            
                    Form {
                        Section(header: Text("Select Mulitipliers for Quizzing")) {
                            LazyVGrid(columns: fourColumnGrid, spacing:20){
                            ForEach(1 ..< 13) { number in
                                Button(action: {
                                    self.buttonTapped(number-1)
                                }) {
                                    Text("\(number)")
                                        .frame(width: 60, height: 50)
                                        .background(Color(userSettings.tableChoices[number-1] == 1 ? .green : .systemGray6))
                                        .border(Color.gray)
                                    }
                                .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }

                        Section(header: Text("How Many Questions Do You Want?")) {
                            Picker("How Many Questions?", selection: $numberOfQuestion) {
                                ForEach(0 ..< numberOfQuestions.count) {
                                    Text("\(self.numberOfQuestions[$0])")
                                }
                                .onChange(of: numberOfQuestion, perform: { (value) in
                                    userSettings.numberChosen = numberOfQuestion
                                                    })
                            } .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Button(action: {
                            userSettings.start()
                            userSettings.readyToPlay = true
                            }){
                                HStack {
                                    Spacer()
                                    Text("START QUIZ")
                                    Spacer()
                                }
                            }
                        }
            }
        }
    
    
    func buttonTapped(_ number: Int) {
        if userSettings.tableChoices[number] == 0 {
            userSettings.tableChoices[number] = 1
        }
        else {
            userSettings.tableChoices[number] = 0
            }
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(UserSettings())
    }
}

