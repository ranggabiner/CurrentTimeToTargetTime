import SwiftUI
import Combine

struct ContentView: View {
    // JSON data
    let jsonData = """
    {
        "time": "09:55"
    }
    """.data(using: .utf8)!

    // Target time
    @State private var targetTime: Date?

    // Current time
    @State private var currentTime: Date = Date()

    // Countdown
    @State private var countdown: String = ""

    // Define the body property which returns a view hierarchy
    var body: some View {
        VStack {
            // Display the current time
            Text("Current Time: \(currentTime, formatter: timeFormatter)")

            // Display the countdown
            Text("Countdown: \(countdown)")

            // Define a button to set the target time
            Button(action: {
                // Parse JSON data
                let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: String]
                let targetTimeString = json["time"]!
  
                // Convert target time to Date object
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                self.targetTime = dateFormatter.date(from: targetTimeString)
                self.updateTime() // Update the countdown immediately after setting the target time
            }) {
                Text("Set Target Time")
            }

            // Define a timer to update the current time and countdown every second
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                self.updateTime()
            }
        }
    }

    // Define a timeFormatter property to format the date as a string
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    // Define a function to update the current time and countdown
    // Define a function to update the current time and countdown
    private func updateTime() {
        // Update current time
        self.currentTime = Date()

        // Calculate countdown
        guard let targetTime = targetTime else { return }
        
        let currentComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
        let targetComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: targetTime)
        
        let currentSeconds = (currentComponents.hour! * 3600) + (currentComponents.minute! * 60) + currentComponents.second!
        let targetSeconds = (targetComponents.hour! * 3600) + (targetComponents.minute! * 60) + targetComponents.second!
        
        let remainingSeconds = targetSeconds - currentSeconds
        
        if remainingSeconds >= 0 {
            let hours = remainingSeconds / 3600
            let minutes = (remainingSeconds % 3600) / 60
            let seconds = (remainingSeconds % 3600) % 60
            self.countdown = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.countdown = "Waktu sudah menunjukkan \(timeFormatter.string(from: targetTime))"
        }
    }
}

// Define a ContentView_Previews struct to preview the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
