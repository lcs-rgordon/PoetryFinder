import SwiftUI

// Example JSON response
//
// This illustrates how to handle a JSON response which
// provides an array of objects.
//
// Recall that arrays are denoted by [ ] brackets.
//
// Objects are denoted by { }. Any time an object is provided,
// you must design a Swift structure to match it.
//
// From endpoint: https://poetrydb.org/random/1
//
// Documentation: https://github.com/thundercomb/poetrydb#readme
//
let exampleResponse = """
 
 [
   {
     "title": "Sonnet XLIV: Press'd by the Moon",
     "author": "Charlotte Smith",
     "lines": [
       "Press'd by the Moon, mute arbitress of tides,",
       "While the loud equinox its power combines,",
       "The sea no more its swelling surge confines,",
       "But o'er the shrinking land sublimely rides.",
       "The wild blast, rising from the Western cave,",
       "Drives the huge billows from their heaving bed;",
       "Tears from their grassy tombs the village dead,",
       "And breaks the silent sabbath of the grave!",
       "With shells and sea-weed mingled, on the shore",
       "Lo! their bones whiten in the frequent wave;",
       "But vain to them the winds and waters rave;",
       "They hear the warring elements no more:",
       "While I am doom'dâ€”by life's long storm opprest,",
       "To gaze with envy on their gloomy rest."
     ],
     "linecount": "14"
   }
 ]

"""

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
        
        // Use the decoder object to convert the raw data into an array of the Poem data type
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

// "View"
//
// A text-based presentation of results is provided, since
// the purpose of this playground is only to illustate how to
// build a model to match the data returned by an endpoint
//
Task {
    // Get a poem
    let somePoem = await fetch()
    
    // So long as a poem was returned, show the first line of output
    if somePoem != nil {
        print(somePoem!.lines.first!)
    }
}


