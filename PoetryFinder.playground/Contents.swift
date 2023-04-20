import SwiftUI

// Model
//
//
struct Poem: Codable {
    
    let title: String
    let author: String
    let lines: [String]
    let linecount: String
    
}

// Network service
//
//
func fetch() async -> Poem? {

    // 1. Attempt to create a URL from the address provided
    let endpoint = "https://poetrydb.org/random/1"
    guard let url = URL(string: endpoint) else {
        print("Invalid address")
        return nil
    }

    // 2. Fetch the raw data from the URL
    //
    // Network requests can potentially fail (throw errors) so
    // we complete them within a do-catch block to report errors if they
    // occur.
    //
    do {
        
        // Fetch the data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Create a decoder object to do most of the work for us
        let decoder = JSONDecoder()
        
        // Use the decoder object to convert the raw data into an instance of our Swift data type
        let decodedData = try decoder.decode([Poem].self, from: data)

        // If we got here, we have received an array of poems
        if decodedData.count > 0 {
            // There is at least one poem, so we can force-unwrap and return just the first poem
            return decodedData.first!
        } else {
            return nil
        }
        
    } catch {
        
        // Show an error that we wrote and understand
        print("Count not retrieve data from endpoint, or could not decode data.")
        print("----")
        
        // Show the detailed error to help with debugging
        print(error.localizedDescription)
        return nil
        
    }

    
}

// View
//
//
Task {
    // Get a poem
    let somePoem = await fetch()
    
    // So long as a poem was returned, show the first line of output
    if somePoem != nil {
        print(somePoem!.lines.first!)
    }
}

