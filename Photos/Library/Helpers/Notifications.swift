import Foundation

extension Notification.Name {

    static let DidReceivePush = Notification.Name(rawValue: "DidReceivePush")

}

extension Notification.Name {

    typealias TokenType = NSObject

    struct Tokens {
        static var tokens = [String: Set<TokenType>]()
    }

    static let dataKey = "data"

    func observe(_ key: Any, handler: @escaping ()->()) {
        observe(key) { (_, _) in
            handler()
        }
    }
    func observe(_ key: Any, handler: @escaping (Any?)->()) {
        observe(key) { (data, _) in
            handler(data)
        }
    }

    func observe(_ key: Any,  handler: @escaping (Any?, Notification)->()) {
        let token = NotificationCenter.default.addObserver(forName: self, object: nil, queue: nil) { (notification) in
            let data = notification.userInfo?[Notification.Name.dataKey]
            handler(data, notification)
        }

        let stringKey = String(describing: key)

        var tokens = Tokens.tokens

        var keyTokens = tokens[stringKey] ?? Set<TokenType>()
        keyTokens.insert(token as! TokenType)

        tokens[stringKey] = keyTokens
        Tokens.tokens = tokens
    }

    func post(data: Any? = nil, sender: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        var userInfo = userInfo
        if data != nil {
            if userInfo == nil {
                userInfo = [AnyHashable : Any]()
            }

            userInfo![Notification.Name.dataKey] = data
        }

        NotificationCenter.default.post(name: self, object: sender, userInfo: userInfo)
    }

    static func remove(_ key: Any) {
        let stringKey = String(describing: key)

        var tokens = Tokens.tokens

        if let keyTokens = tokens[stringKey] {
            keyTokens.forEach {
                NotificationCenter.default.removeObserver($0)
            }
        }

        tokens[stringKey] = nil
        Tokens.tokens = tokens
    }

}
