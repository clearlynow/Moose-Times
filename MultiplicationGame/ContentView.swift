//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Alison Gorman on 1/27/21.
//

import SwiftUI


struct ContentView: View {
    
    // detect if iPad or iOS
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var isPortrait : Bool { UIDevice.current.orientation.isPortrait }
    
    // Game Properties
    @State private var answer = ""
    @State private var count = 0
    @State private var score = 0
    
    struct Table {
        var enabled : Bool
        var number : Int
        var animal : String
        var level1 : Bool
        var animalSize: CGFloat
    }
    
    @State var TT = [Table(enabled: false, number: 1, animal: "sloth", level1: false, animalSize: 60),
                            Table(enabled: false, number: 2, animal: "bear", level1: false, animalSize: 60),
                            Table(enabled: false, number: 3, animal: "walrus", level1: false, animalSize: 60),
                            Table(enabled: false, number: 4, animal: "penguin", level1: false, animalSize: 60),
                            Table(enabled: false, number: 5, animal: "panda", level1: false, animalSize: 60),
                            Table(enabled: false, number: 6, animal: "dog", level1: false, animalSize: 55),
                            Table(enabled: false, number: 7, animal: "moose", level1: false, animalSize: 50),
                            Table(enabled: false, number: 8, animal: "pig", level1: false, animalSize: 50),
                            Table(enabled: false, number: 9, animal: "rabbit", level1: false, animalSize: 45),
                            Table(enabled: false, number: 10, animal: "giraffe", level1: false, animalSize: 45),
                            Table(enabled: false, number: 11, animal: "cow", level1: false, animalSize: 40),
                            Table(enabled: false, number: 12, animal: "rhino", level1: false, animalSize: 40)]
    
    // Game State
    @State var showSettings = false
    @State var showHome = true
    var gameOver : Bool {
        count > 0 && count == gameQuestions.count
    }
    
    // Questions
    struct Question: Hashable {
        var first: Int
        var second: Int
        var answer: Int {first * second}
        var enteredAnswer: Int
        
        var correct: Bool {
            answer == enteredAnswer
        }
    }
    
    @State var gameQuestions : [Question] = []
    @State var allQuestions : [Question] = []
    @State var answersArray = [0,0,0,0]
    @State var answersSet : Set<Int> = []
    
    // Settings Properties
    @State var name : String = "Smelly Cat"
    @State var tableChoices = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @State var numberChosen = 3
    @State var numberOfQuestion = 0
    @State var chosenMaxMultiplier = 10
    @State var showAnimals = true
    @State var multipleChoice = true

    let numberOfQuestions = ["5", "10", "20", "All"]
    private var fourColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    // ANIMATIONS
    @State var rotateValue = 0.0
    @State private var animateCorrect = false
    @State private var animateWrong = false
    
    func rotateNumber() {
        withAnimation(.linear(duration: 0.4)) {
            self.rotateValue += 360
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animateCorrect = false
            animateWrong = false
            answer = ""
            count += 1
            if count < gameQuestions.count {
                getChoices()
            }
        }

    }
    
    func padTapped(_ number: String) {
        if answer.count <= 2 {
            answer += number
        }
    }
    
    func buttonTapped(_ number: Int) {
        if tableChoices[number] == 0 {
        tableChoices[number] = 1
        }
        else {
            tableChoices[number] = 0
            }
    }
    
    func playTable(_ number: Int) {
        for x in 0...11 {
            if number == x { tableChoices[x] = 1 }
            else { tableChoices[x] = 0 }
        }
    }
    
    func resetAnswer() {
        answer = ""
    }
    
    
    func checkAnswer() {
        //animateCorrect = false
        //animateWrong = false
        gameQuestions[count].enteredAnswer = Int(answer) ?? 0
        if (gameQuestions[count].correct) {
            score += 1
        }
        rotateNumber()

    }
    
    func start() {
        //clear everything
        allQuestions.removeAll()
        gameQuestions.removeAll()
        count = 0
        score = 0
        
        //get all possible questions
        for i in 0...11 {
            for j in 1...chosenMaxMultiplier {
                if tableChoices[i] == 1 {
                    allQuestions.append(Question(first: i+1, second: j, enteredAnswer: 0))
                }
            }
        }
        
        //get chosen amount of questions for Game
        var n = 0
        switch numberChosen{
            case 3: n = allQuestions.count //all
            case 0: n = 5
            case 1: n = 10
            case 2: n = 20
            default: n = 5
            }
        n = allQuestions.count > n ? n : allQuestions.count
        for _ in 1...n {
            let randomIndex = Int(arc4random_uniform(UInt32(allQuestions.count)))
            let q = allQuestions.remove(at: randomIndex)
            gameQuestions.append(q)
            answersSet.insert(q.answer) // for multiple choice
            }
        getChoices()
    }
    
    func getChoices() {
        answersArray[0] = gameQuestions[count].answer
        while answersArray[1] == 0 || answersArray[1] == answersArray[0] {answersArray[1] = answersSet.randomElement() ?? 5 }
        while answersArray[2] == 0 || answersArray[2] == answersArray[0] || answersArray[2] == answersArray[1] {answersArray[2] = answersSet.randomElement() ?? 10 }
        while answersArray[3] == 0 || answersArray[3] == answersArray[0] || answersArray[3] == answersArray[1] || answersArray[3] == answersArray[2] {answersArray[3] = answersSet.randomElement() ?? 15 }
        answersArray.shuffle()
    }
    
    
    var body: some View {

        ZStack {

            /* ------------ Play Game -------------------*/
            if !showSettings && !gameOver && !showHome{
                HStack (spacing:20){
                    
                    if !showAnimals {
                        HStack{
                            Spacer()
                            questionView
                                .frame(width:300)
                                .padding()
                                
                            Spacer()
                            }
                            .background(SwiftUI.Color.blue)
                        }
                    else {
                        Spacer()
                            HStack{
                                Spacer()
                        
                                animalView
                                    .padding()
                                    //.background(SwiftUI.Color.pink)
                                    Spacer()
                        
                                questionView
                                    .frame(width:300)
                                    .padding()
                                    .background(SwiftUI.Color.blue)
                            }
                    }
                    
                    }
                    .background(SwiftUI.Color.yellow.edgesIgnoringSafeArea(.all))
                }
        
            /* ---------- Home -------------------------*/
            if showHome {
                HStack{
                    Spacer()
                    homeView
                    Spacer()
                }
                .background(SwiftUI.Color.blue.edgesIgnoringSafeArea(.all))
            }
                
            /* ------------- Settings -------------------*/
            if showSettings && !showHome{
                HStack{
                    Spacer()
                    settingsView
                        .animation(.interactiveSpring())
                    Spacer()
                    }
                    .background(SwiftUI.Color.yellow.edgesIgnoringSafeArea(.all))
                }
            
            /* ------------ Game Over ---------------*/
            if gameOver && !showSettings && !showHome{
                HStack{
                    Spacer()
                    doneView
                    Spacer()
                }
                .background(SwiftUI.Color.green.edgesIgnoringSafeArea(.all))
            }
        
        } // End ZStack
        .edgesIgnoringSafeArea(.all)
        
        
    } // End Body
    
    
    var animalView: some View {

        VStack (alignment: .center, spacing: 5){
            ForEach(1...(gameQuestions[count].second), id: \.self) { i in
                HStack (spacing: 8){
                    Text("\(i) ")
                    let q = gameQuestions[count].first
                    ForEach(1...(q), id: \.self) {_ in
                        Image(TT[q-1].animal)
                            .resizable()
                            .frame(width:TT[q-1].animalSize, height:TT[q-1].animalSize)
                    }

                }
                .padding(5)
                .background(Color(red: 243/255, green: 186/255, blue: 109/255, opacity: 0.7))
                .overlay(Rectangle().stroke(Color.clear).shadow(radius: 0.5))
            }
            //.transition(.opacity)
            //.animation(.default)
        }
    }
    
    var choicesView: some View {
        
        ForEach(0 ..< 4) { number in
            Button(action: {
                if (answersArray[number] == gameQuestions[count].answer) {
                    withAnimation(.default){
                        animateCorrect = true
                        }
                    }
                else {
                    withAnimation(.default){
                        animateWrong = true
                    }
                }
                answer = String(answersArray[number])
                checkAnswer()

            }) {
                ZStack {
                Text(String(answersArray[number]))
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(SwiftUI.Color.blue)
                    .frame(width:200, height:80)
                    .background(SwiftUI.Color.yellow)
                    .overlay(Rectangle().stroke(Color.clear).shadow(radius: 0.5))
                    //.rotation3DEffect(.degrees( answersArray[number] == gameQuestions[count].answer && animateCorrect ? 360.0 : 0.0), axis: (x: 0, y: 0, z: 1))
                    //.opacity(answersArray[number] != gameQuestions[count].answer && animateCorrect ? 0.25 : 1)
                    //.overlay(animateWrong ? Capsule().fill(Color.red) : nil)
                    if animateCorrect && answersArray[number] == gameQuestions[count].answer {
                        Text("✅")
                            .font(.largeTitle)
                        }
                    else if animateWrong && answersArray[number] == gameQuestions[count].enteredAnswer {
                        Text("❌")
                            .font(.largeTitle)
                        }
                }
            }
        }
    }
    
    var questionView: some View {
        VStack (spacing: 30) {
            Spacer()
            
            // Question Box
            VStack {
                HStack(alignment: .center, spacing: 10) {
                        Text(String(gameQuestions[count].second))
                                .bold()
                                .font(.largeTitle)
                                .frame(width:80, height: 80)
                                .background(Color(.cyan))
                                .rotation3DEffect(Angle.degrees(rotateValue), axis: (x: 0, y: 1, z: 0) )
                    //AskedNumber(number: String(gameQuestions[count].first))
                    Text("X").font(.largeTitle)
                    
                        Text(String(gameQuestions[count].first))
                            .bold()
                            .font(.largeTitle)
                            .frame(width:80, height: 80)
                            .background(Color(.cyan))

                }
                .padding()
                .background(
                    Color(red: 243/255, green: 186/255, blue: 109/255, opacity: 0.7)
                    //                            .blur(radius: 8)
                )
                .overlay(
                    Rectangle()
                        .stroke(Color.clear)
                        .shadow(radius: 0.5)
                )
                }
            
        
            Spacer()
            if !multipleChoice {
                keyboardView
            }
            else {
                choicesView
            }
            Spacer()

            // Bottom Right - Question #/# and Settings Button
            HStack {
                Spacer()
                
                // Question # / #
                HStack() {
                    HStack {
                        Text("Question ")
                        Text("\(count+1)")
                            .fontWeight(.heavy)
                        Text(" of ")
                        Text("\(gameQuestions.count)")
                    }
                }
                // end Question #
                
                // Home Button
                    Button(action: {
                                showHome.toggle()
                            }) {
                                Image(systemName: "house.circle.fill")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(Color(.cyan))
                                }
                    .padding()
            }
            .padding()// end Bottom Right
        } // end VStack
    } // end questionView
    
    var settingsView: some View{
        VStack(spacing: 15) {
            

        /* For Selecting Muliple Tables - not used right now
            VStack {
                Section(header: Text("Select Mulitipliers for Quizzing")) {
                    LazyVGrid(columns: fourColumnGrid, spacing:20){
                        ForEach(1 ..< 13) { number in
                            Button(action: {
                                self.buttonTapped(number-1)
                                }) {
                                    Text("\(number)")
                                        .frame(width: 50, height: 50)
                                        .background(Color(tableChoices[number-1] == 1 ? .cyan : .systemGray6))
                                        .cornerRadius(10)
                                    }
                                .buttonStyle(PlainButtonStyle())
                                }
                        }
                    }
                }
             */
            
            /* for selecting number of questions - not used right now
                VStack{
                    Text("Select Number of Questions")
                    Picker("How Many Questions?", selection: $numberOfQuestion) {
                        ForEach(0 ..< numberOfQuestions.count) {
                            Text("\(self.numberOfQuestions[$0])")}
                                .onChange(of: numberOfQuestion, perform: { (value) in numberChosen = numberOfQuestion})
                                } .pickerStyle(SegmentedPickerStyle())
                    }
             */
            Spacer()
            
            Text("Settings")
                .font(.largeTitle)
            
            Group{
                VStack (alignment: .center){
                Text("Who's Playing: ")
                TextField("Name", text: $name)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(7)
            
            Divider()
            
            HStack{
                Text("Max Multiplier")
                Picker("", selection: $chosenMaxMultiplier) {
                    Text("10").tag(10)
                    Text("12").tag(12)
                    } .pickerStyle(SegmentedPickerStyle())
                }
                
            Divider()


                Picker("", selection: $multipleChoice) {
                    Text("Keyboard Entry").tag(false)
                    Text("Multiple Choice").tag(true)
                    } .pickerStyle(SegmentedPickerStyle())
                
                
            Divider()
                Toggle("Visualize Questions (iPad only)", isOn: $showAnimals)
                    .disabled(idiom != .pad)
            }
                    
            Divider()
            Button(action:  {
                    showSettings = false
                    showHome = true
            } ) {
                Text("Save")
                .font(.title)
                .foregroundColor(Color.black)
                .frame(width: 200, height: 44)
                .background(Color(.cyan))
                .cornerRadius(7)
            }
            
            Spacer()
        }
        .frame(width:400)
    } // end settingsView
    
    var homeView: some View{
        VStack(spacing: 15) {
            Spacer()
            
            Text("Hello \(name)!")
                .font(.largeTitle)
            
            VStack {
                Section(header: Text("Which Table Do You Want To Play?")) {
                    LazyVGrid(columns: fourColumnGrid, spacing:40){
                        ForEach(0 ..< 12) { number in
                            Button(action: {
                                self.playTable(number)
                                showHome = false
                                showSettings = false
                                start()
                                }) {
                                VStack (alignment: .center, spacing: 2) {
                                    Text("\(number+1)")
                                        .font(.largeTitle)
                                    Image(TT[number].animal)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                    }
                                .padding()
                                .frame(width:100, height: 140)
                                .background(Color.orange)
                                .cornerRadius(7)
                            }
                                .buttonStyle(PlainButtonStyle())
                                }
                        }
                    }
                }
            .frame(width:500)
            
            Spacer()
            
            HStack {
                Spacer()
                // Settings Button
                    Button(action: {
                                showHome = false
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(Color(.cyan))
                                }
                    .padding()
            }
            
        }
    } // end homeView
    
    var doneView: some View{
        VStack(spacing: 40) {
            Spacer()
            
            VStack (alignment: .leading, spacing: 5) {
            ForEach (gameQuestions, id: \.self) { Q in
                HStack {
                    if Q.correct {
                        Text("✅ \(Q.second) X \(Q.first) = \(Q.enteredAnswer)")
                    }
                    else{
                        HStack {
                            Text("❌ \(Q.second) X \(Q.first) =")
                            Text("\(Q.enteredAnswer)")
                                .foregroundColor(Color(.red))
                                .strikethrough()
                            Text("\(Q.answer)")
                                .bold()
                        }
                        //.font(.largeTitle)
                    }
                    }
                }
            }
            .font(.largeTitle)
            
            if score == count {
                Text("""
                    Woohoo, \(name)!
                    You got them all right! ⭐️
                    """)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
            else
            {
                Text("""
                    Oopsy!
                    You got \(count-score) wrong.
                    """)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }

            // Play Button
            
            Button(action:  {
                    start()
                    count = 0
                    score = 0
                    showSettings = false
                    showHome = true
            } ) {
                Text("Play Again!")
                .bold()
                .font(.title)
                .foregroundColor(Color.black)
                .frame(width: 200, height: 44)
                .background(Color(.cyan))
                .cornerRadius(7)
            }
            

            Spacer()

        }
    }
    
    


    var keyboardView: some View {
    // Keyboard View
    VStack {
            
        // Display
        HStack {
            Text(answer)
                    .frame(width: 170, height: 50, alignment: .center)
                    .frame(idealWidth: 170, maxWidth: 170)
                    .font(.title)
                    .foregroundColor(Color("color1"))
                    .background(Color(.white))
                    .cornerRadius(8)
                

                    Image("roundWood")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .overlay(
                        Button(action: {
                            checkAnswer()
                        }) {
                            Image(systemName: "arrow.up.circle.fill").resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("color2"))
                        }
                        .frame(width: 50, height: 50)
                    )
                }
                .frame(height: 50)
                .frame( minHeight: 50, idealHeight: 50, maxHeight: 50)
                .padding(.bottom, 10)
    
        // Line 123
            HStack {
                Image("woodPad").resizable()
                    .modifier(vm_pad())
                    .overlay(
                        Button(action: { self.padTapped("1") }) {
                            padContent(number: "1")
                        }
                )
                Image("woodPad").resizable()
                    .modifier(vm_pad())
                    .overlay(
                        Button(action: { self.padTapped("2") }) {
                            padContent(number: "2")
                        }
                )
                Image("woodPad").resizable()
                    .modifier(vm_pad())
                    .overlay(
                        Button(action: { self.padTapped("3") }) {
                            padContent(number: "3")
                        }
                )
            }
        
            // Line 456
            HStack {
                HStack {
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("4") }) {
                                padContent(number: "4")
                            }
                    )
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("5") }) {
                                padContent(number: "5")
                            }
                    )
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("6") }) {
                                padContent(number: "6")
                            }
                    )
                }
            }
        
            // Line 789
            HStack {
                HStack {
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("7") }) {
                                padContent(number: "7")
                            }
                    )
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("8") }) {
                                padContent(number: "8")
                            }
                    )
                    Image("woodPad").resizable()
                        .modifier(vm_pad())
                        .overlay(
                            Button(action: { self.padTapped("9") }) {
                                padContent(number: "9")
                            }
                    )
                }
            }
        
            // Line 0 + clear
            HStack {
                
                Image("roundWood").resizable()
                    .modifier(vm_pad())
                    .overlay(
                        Button(action: { self.resetAnswer() }) {
                            Image(systemName: "delete.left.fill")
                                .foregroundColor(.white)
                        }
                )
                
                
                Image("woodPad").resizable()
                    .modifier(vm_pad())
                    .overlay(
                        Button(action: { self.padTapped("0") }) {
                            padContent(number: "0")
                        }
                )
                
                Text("")
                    .frame(width: 70, height: 50)
                
            } //end 0 + clear
            .padding(.top, 5)
        
        } // end display+keyboard vstack
    } // end keyboard group
}


 // End ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
