import UIKit

// we will look at various string methods/properties/formatting

// --- PART 1 --- STRINGS ARE NOT ARRAYS ---
let name = "Vaughn"

// can loop and print the letters...
for letter in name {
    print("Give me a \(letter)!")
}
// but can't read individual letters with...
print(name[3])
// we need to start at the beginning and count through each letter until getting to the one we're looking for
let letter = name[name.index(name.startIndex, offsetBy: 3)]
// if we want to read just name[3] we can add this expression...
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

// if you're looking to empty a string it's better/quicker to use...
someString.empty
// than
someString.count == 0


// --- PART 2 --- WORKING WITH STRINGS ---

let password = "12345"

password.hasPrefix("123")
password.hasSuffix("345")

// can add extension methods to String to extend the way prefixing and suffixing work

extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        // dropFirst removes a certain number of letters
        return String(self.dropFirst(prefix.count))
    }
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}


let weather = "it's going to rain"
// will print "It's Going To Rain"
print(weather.capitalized)

// this will capitalize only the first letter in our string
extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let input = "Swift is like Objective-C without the C"
// true
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
// true
languages.contains("Swift")

// to check if any string in array exists in input string
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
// we can now run but there is a better method built into Swift...
input.containsAny(of: languages)

// by passing one function directly into the other
languages.contains(where: input.contains)
// contains(where:) will call its closure once for every element in languages array until it finds one that returns true, at which point it stops
// input.contains is the closure that contains(where:) should run, which means Swift will call input.contains("Python") and get false and so on

// --- PART 3 --- Formatting Strings with NSAttributedString ---

// Swift strings are plain text, but sometimes we want to add formatting like italics/bold/etc with class NSAttributedString
// attributed strings are made of two parts, a plain Swift string plus a dictionary containig a series of attributes that describe how various segments of the string are formatted
let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

// can add formatting to different parts of the string
let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

// .underlineStyle, .strikethroughStyle, .paragraphStyle, .link
// UILabel, UITextField, UITextView, UIButton, UINavigationBar all support attributed and regular strings - to use in a label for example you use attributedText instead of just text and UIKit takes care of the rest
