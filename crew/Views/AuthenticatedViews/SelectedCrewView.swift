//
//  SelectedCrewView.swift
//  crew
//
//  Created by Hari Krishna on 12/13/22.
//  SelectedCrewView: Contains the current space icon to go the side menu view along with the
//  default meme crew name that ucla students join when they sign up with a scenic square photo header
//  at the top right

import SwiftUI

struct SelectedCrewView: View {
    @Binding var currentFloatIndex: CGFloat
    
   
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                
                SelectedCrewHeaderView(currentFloatIndex: $currentFloatIndex)

            }
            
        }
        .onTapGesture {
            if currentFloatIndex == 0.0 {
                currentFloatIndex = 1.0
            }
        }
        
    }
}


struct SelectedCrewHeaderView: View {
    @Binding var currentFloatIndex: CGFloat

    // MARK: below variables are used to trigger a randoom element from an array of titles to make user feel good
    // while the current selected crew title loads
    @State var seenSelectedCrewFirstAppOpen: Bool = false
    @State var loadingRandomCrewTitle: Bool = false
    @State var randomCrewTitle: String = ""

    @State var feelGoodArray = ["let's grow old together", "what if we held hands right now 😏", "you are so loved", "welcome to the crew full of hot people", "feeling what i think is... love", "let's kiss at the sculpture garden", "quick fit check!! looking good 🤝", "loving you is easy", "i want to celebrate you every single day", "let's hug it out?", "wow so cool i just won the nobel peace prize for bringing the crew together", "we were never really strangers", "party at my place? i'm on aux", "can we go to in-n-out please", "just checking up on you :)", "you smiled, i fell in love", "let's sit up all night and watch the sunrise together", "i got a feeling. that tonight's gonna be a good night", "now i'm feelin' so fly like a g6", "'cause baby, tonight the dj got us falling in love again", "you've got them moves like jagger", "tick tock on the clock, but the party don't stop, no", "yeah, it's a party in the u.s.a", "i fly like paper, get high like planes", "you've got your own thing, that's why i love you", "everybody just have a good, good, good time", "get up, get down, put your hands to the sound", "times square can't shine as bright as you", "i got lost in your eyes and i couldn’t find an exit", "you’re worth keeping. forever", "do you mind?? i was trying not to fall in love today", "sooo grateful for the crew", "can’t wait to get the crew together this weekend", "i've known since the moment i've met you, this was something special", "oh this love we have? It’s our little secret", "cant remember the last time I felt this way about someone", "for small beings such as we the vastness is only bearable through love", "you’re my day 1 :)", "there you are!! now I can have a good day", "good morning, good evening, good everything :)", "beautiful world, full of beautiful people like you :)", "if this isn't nice then what is", "i think my heart just skipped a beat haha :)",
        // USC jokes below, think about user feelings here
        "what do you call a usc graduate in a three-piece suit? ...the defendant", "what do usc and ucla students have in common?...they both got into usc", "please tell me you feel the same way", "what does the average usc player get on their sats? ...drool", "why do students choose usc over ucla? ...it's easier to spell", "why is usc referred to as a private school? ...nobody wants it to be publicly known that they went there", "what do you get when you drive slowly by the usc campus? ...a degree", "did you hear the usc library burned down? ...they lost both books, and one hadn't even been colored in yet", "i just know you have a heart of gold", "don't rush the things you want to last forever", "you couldn't possibly mean more to me", "geology majors are really down to earth", "what are the best four year of a usc trojan's life ...third grade", "how many usc freshmen does it take to screw in a light bulb? ...none, that's a sophomore course"]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 50, height: 50)
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color(#colorLiteral(red: 0, green: 0.8145048022, blue: 0.8413854837, alpha: 0.8470588235))]), startPoint: .trailing, endPoint: .leading).mask(
                        Image("crew")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 22)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.white)
                        )
                )
                .padding(.top, -3)
                .padding(.leading, 10)
                .onTapGesture {
                    if currentFloatIndex == 0.0 {
                        currentFloatIndex = 1.0
                    } else if currentFloatIndex == 1.0 {
                        currentFloatIndex = 0.0
                    }
                }
                
                // show feel good text while crew title loads
                if !seenSelectedCrewFirstAppOpen {
                    Text("\(randomCrewTitle)")
                        .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                        .underline()
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(width: 0.7 * UIScreen.main.bounds.size.width, alignment: .topLeading)
                        .padding(.leading, 2)
                    
                        
                } else {
                    Text("ucla memes for sick af teens")
                        .font(.system(size: UIScreen.main.bounds.size.height > 800 ? 28 : 24))
                        .underline()
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(width: 0.7 * UIScreen.main.bounds.size.width, alignment: .topLeading)
                        .padding(.leading, 2)
                }
                
                
                Spacer()
                
                Image("ucla")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 40, height: 40)
                  .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                  .padding(.trailing, 20)
                  .padding(.top, 5)

            }
            Spacer()
        }
        .padding(.top, 20)
        .onChange(of: currentFloatIndex) { newValue in
            if newValue == 1 && !loadingRandomCrewTitle {
                randomCrewTitle = feelGoodArray.randomElement()!
                loadingRandomCrewTitle = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                  withAnimation {
                      seenSelectedCrewFirstAppOpen = true
                  }
                }
            }
        }
    }
}
