import Foundation

func generateURL(action: Action, deeplink: Deeplink) -> String? {
    var components = URLComponents()
    var queryItems: [URLQueryItem] = []

    components.scheme = "https"
    components.host = "www.adoreme.com"
    queryItems.append(contentsOf: deeplink.queryItems)

    if let token = action.userToken {
        queryItems.append(URLQueryItem(name: "am_sl", value: token))
    }

    if !queryItems.isEmpty {
        components.queryItems = queryItems
    }

    var path = deeplink.path

    if queryItems.isEmpty && deeplink.path == "/" {
        path = ""
    }

    components.path = path

    return components.url?.absoluteString
}

func generateFirebaseDynamicLinkURL(urlString: String) -> String? {
    let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

    var components = URLComponents()
    components.scheme = "https"
    components.host = "link.adore.me"

    var queryItems: [URLQueryItem] = []
    queryItems.append(URLQueryItem(name: "link", value: encodedUrlString))
    queryItems.append(URLQueryItem(name: "apn", value: "com.adoreme.android"))
    queryItems.append(URLQueryItem(name: "isi", value: "661053119"))
    queryItems.append(URLQueryItem(name: "ibi", value: "com.adoreme.qmobile"))
    components.queryItems = queryItems

    return components.url?.absoluteString
}

