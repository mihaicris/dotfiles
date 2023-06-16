import Foundation

let userExVip = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJ6bFMwRVZycnFWS3duOXRmTnFpVDJQMXFlMGZPWmRiejZWcHVVMFBCTTgifQ.eyJleHAiOjE3MDIzNTMwMDgsImlzcyI6Ikd3LU1haW4iLCJpYXQiOjE2ODY1NzMwMDgsImF1ZCI6ImF1dGhvcml6YXRpb24iLCJqdGkiOiIyZTk5YjFhYi04MTAyLTQwZmUtYjllMi02ZWI1MTczNDcwOTEiLCJzdWIiOjI1OTQ4MzA0fQ.lY_zehZtVtqvIlQ1KQPYYNN-2zRQSFWiyJTbPyyggkZx5ZLcNXTg12RMHl9RRVXfpNQAdvRMqQZvGPS8DKnyBy8bTxwiV97p_ltWTzGpkPqeIFNC61ZvF4eM5doSD_lXI6RN3PSkC6cDyU6uOY11tttNjV5iXEkXsO19kY-W0jbaX3ocyrfCHP28hP0it7kNkRoO_m8Vw-8O0hF4nqx5c_Dus-j05H33GykRSuzOqt2hrwutwCLoKNGoH1BrKaCe898g2Ppy9SNcSbI7TYA3i4FqnVODpf87V_v1pnUY3_nlRQyNJincG9JEF4944k5Q5EuHl2WPRdKbUw-dBPWepw"
let userVip = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJ6bFMwRVZycnFWS3duOXRmTnFpVDJQMXFlMGZPWmRiejZWcHVVMFBCTTgifQ.eyJpc3MiOiJHdy1NYWluIiwiaWF0IjoxNjQ5MjQzNjQ2LCJleHAiOjE2NjUwMjM2NDYsInN1YiI6IjI1NjM2NjU2In0.rJsWpyTguBi9CI671QslBflLR3n3J6vceGQKwwEDdO-tlucMZa0mOlwF6PscLbB50h3HJMg3MA0PPxPYh_I4ors_DSvRrefbzf2dOTxMT3KRvcfR09zzorUaYSt8_BjNMp44cbvUgA7rTBPC6RU1LCqNltOa3HRbSAsaiaBfX0ixgUYf4hnsc5GEVQq06dhzbZodoWQpa9pJwOBvY-sExYWuKVsVNYie9m3fVjR_cj6Kru2ojrAKnF8snGGs-fAwGmgrKeql2D4QUc7OIOOzM2yXxomrKWQ5PevapL0xvqQfkzwXVjkFraxEUtY6-j0-pskbvaZt4E8jL_ZJwYWaPQ"

let userElite = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJ6bFMwRVZycnFWS3duOXRmTnFpVDJQMXFlMGZPWmRiejZWcHVVMFBCTTgifQ.eyJpc3MiOiJHdy1NYWluIiwiaWF0IjoxNjQ5MjUyMTg0LCJleHAiOjE2NjUwMzIxODQsInN1YiI6IjI2MzkyODU0In0.nRtn0ZOt8AMvTP2Bt1QfwmfVwrOiC9CnWkthr4jGG4Wu9zRRJ-dYx5wQkXzrfN9pRAGTbGc2QHHdIbdVh3_UFvRxYFAcqtPq01hT-KcQe2CmdZ0hugFPvoAmo7E6tmVMuRCCV5XtdpxMgSPjFBqL9MrNuOloQbJH7sPmOkCyXnD40Fx_T7s57kOKrjuFnwHjoNu0CLMbKbRtaU9yT5yO6YsUMkYlvg3hTAdd8BBa5e_Ki9yCMYch4DbLipCNDE9DMWmefmrWxEVb9cMn1Fpln_ECxwOmk3eTbFxLpqQ3cgDN7hdy7kQCLYO6_erDhtkkbp__FdJLuPawqQxO2j2wxw"

struct Action {
    let title: String
    var userToken: String? = nil
    var deeplink: Deeplink? = nil
}

let actions = [
    Action(title: "No softlogin", userToken: nil, deeplink: nil),
    Action(title: "Logout", userToken: nil, deeplink: .init(path: "/logout")),
    Action(title: "Close app", userToken: nil, deeplink: .init(path: "/close-app")),
    Action(title: "EXVIP", userToken: userExVip, deeplink: nil),
    Action(title: "VIP", userToken: userVip, deeplink: nil),
    Action(title: "ELITE", userToken: userElite, deeplink: nil),
    Action(title: "Firebase DynLink", userToken: nil, deeplink: nil),
    Action(title: "Firebase DynLink EXVIP", userToken: userExVip, deeplink: nil),
    Action(title: "Firebase VIP", userToken: userVip, deeplink: nil),
    Action(title: "Firebase DynLink ELITE", userToken: userElite, deeplink: nil),
]

struct Deeplink {
    var path: String
    let queryItems: [URLQueryItem]

    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
}

let deeplinks: [Deeplink] = [
    "/",
    "/2-pack-sleepwear-surprise-box",
    "/5-for-20",
    "/accesories/bra-lingerie",
    "/bestseller",
    "/bestseller/active",
    "/bestseller/bras-and-panties",
    "/bestseller/bras-bestsellers",
    "/bestseller/legwear",
    "/bestseller/lingerie",
    "/bestseller/lingerie-bestsellers",
    "/bestseller/lounge",
    "/bestseller/panties",
    "/bestseller/plus",
    "/bestseller/sleep",
    "/bestseller/sleepwear-bestsellers",
    "/bestseller/swim",
    "/bras-and-panties",
    "/bras-and-panties/30-36-dd-h",
    "/bras-and-panties/bralette-wireless-bras",
    "/bras-and-panties/full-coverage",
    "/bras-and-panties/lightly-lined",
    "/bras-and-panties/neutral-shades-bras",
    "/bras-and-panties/push-up",
    "/bras-and-panties/racerback",
    "/bras-and-panties/strapless-solution-bras",
    "/bras-and-panties/sustainable-bras",
    "/bras-and-panties/t-shirt-bras",
    "/bras-and-panties/unlined",
    "/bridal-lingerie",
    "/bridal-lingerie/bras-and-panties",
    "/bridal-lingerie/lingerie",
    "/bridal-lingerie/panties",
    "/bridal-lingerie/plus",
    "/bridal-lingerie/sleep",
    "/bridal-lingerie/swim",
    "/cooling-breathable-basics",
    "/early-access",
    "/early-access/active",
    "/early-access/bras-and-panties",
    "/early-access/lingerie",
    "/early-access/lounge",
    "/early-access/plus",
    "/early-access/sleep",
    "/early-access/swim",
    "/face-masks",
    "/loungewear",
    "/loungewear-collection",
    "/loungewear/loungewear-bottoms",
    "/loungewear/loungewear-dresses",
    "/loungewear/loungewear-sets",
    "/loungewear/loungewear-tops",
    "/loungewear/sustainable-loungewear",
    "/mastectomy-bras",
    "/maternity-nursing",
    "/panties",
    "/panties-collections",
    "/panties-offer",
    "/panties-sales",
    "/panties/bikini-and-cheeky",
    "/panties/cotton",
    "/panties/crotchless-strappy",
    "/panties/everyday-basics",
    "/panties/g-string",
    "/panties/high-brief",
    "/panties/hipster-and-shortie",
    "/panties/plus",
    "/panties/romantic",
    "/panties/sustainable-panties",
    "/panties/thong",
    "/panty-packs",
    "/period-panties",
    "/plus/activewear",
    "/plus/bras-panties-1",
    "/plus/lingerie-plus",
    "/plus/loungewear-plus",
    "/plus/sleepwear-1",
    "/plus/swimwear-plus",
    "/sale",
    "/sales",
    "/sales/active",
    "/sales/apparel-sale",
    "/sales/bras-and-panties",
    "/sales/legwear",
    "/sales/lingerie",
    "/sales/lounge",
    "/sales/period-panties",
    "/sales/plus",
    "/sales/sleep",
    "/sales/swim",
    "/sexy-lingerie",
    "/sexy-lingerie/babydolls",
    "/sexy-lingerie/corsets-bustiers",
    "/sexy-lingerie/shapewear",
    "/sexy-lingerie/sheer-socks",
    "/sexy-lingerie/stockings-tights",
    "/sexy-lingerie/sustainable-lingerie",
    "/sexy-lingerie/teddies-bodysuits",
    "/sleepwear-2",
    "/sleepwear-2/pj-cami-sets",
    "/sleepwear-2/robes",
    "/sleepwear-2/robes-slippers-socks",
    "/sleepwear-2/slips",
    "/sleepwear-2/sustainable-sleepwear",
    "/swim",
    "/swim/bikini-two-piece-swimsuits",
    "/swim/high-waisted-swimsuits",
    "/swim/one-piece-swimsuits",
    "/swim/sustainable-swim",
    "/workout-clothes",
    "/workout-clothes/active-workout",
    "/workout-clothes/hoodies-sweatshirts",
    "/workout-clothes/joggers",
    "/workout-clothes/leggings-tights",
    "/workout-clothes/sport-bras",
    "/workout-clothes/studio-yoga",
    "/zodiac-signs-bikini-panties",
    "-----------Pages---------------",
    "/app-survey",
    "/checkout/cart",
    "/customer/account",
    "/customer/account/personal-info/edit",
    "/customer/membership-cancel",
    "/customer/membership-pause/dashboard",
    "/customer/membership-settings",
    "/customer/store-credit",
    "/elite-dashboard",
    "/elite-dashboard/history",
    "/elite-dashboard/my-elite-list",
    "/elite-dashboard/my-preferences",
    "/messages",
    "/messages/{MESSAGE_ID}",
    "/my-showroom",
    "/notifications",
    "/sales/order/history",
    "/sales/order/view/elite_box/{ORDER_ID}/review",
    "/sales/order/view/order_id/{ORDER_ID}",
    "/try-adoreme-elite",
    "/upgrade-to-elite",
    "/wishlist"
].map { Deeplink(path:$0)}

//append(Deeplink(path: "/auth/reset-password", queryItems: [URLQueryItem(name: "reset_password_token", value: "TOKEN_MISSING")]))



func makeDeeplink() {

    // SELECT ACTION
    print("Choose softlogin user: (Press ENTER for no user)")
    let userListing = actions.enumerated().map { index, user in
        let no = String(index).paddingToLeft(upTo: 3)
        return "\(no)) \(user.title)"
    }.joined(separator: "\n")
    print(userListing)
    var answer = readLine(strippingNewline: true) ?? "0"
    var index: Int = answer.isEmpty ? 0 : Int(answer) ?? 0
    guard index >= 0 && index <= actions.count else {
        print("Invalid selection, try again.")
        return
    }
    var action = actions[index]

    // Ask for DEEPLINK if missing
    if action.deeplink == nil {
        print("Choose navigation deeplink: (Press ENTER for no deeplink)")
        let deeplinkListing = deeplinks.enumerated().map { index, link in
            let no = String(index).paddingToLeft(upTo: 3)
            return "\(no)) \(link.path)"
        }.joined(separator: "\n")
        print(deeplinkListing)
        answer = readLine(strippingNewline: true) ?? "0"
        index = answer.isEmpty ? 0 : Int(answer) ?? 0
        guard index >= 0 && index <= deeplinks.count else {
            print("Invalid selection, try again.")
            return
        }

        action.deeplink = deeplinks[index]
    }

    guard var deeplink = action.deeplink else {
        print("Deeplink not set")
        exit(1)
    }

    // ASK for Message ID
    if deeplink.path.contains("{MESSAGE_ID}") {
        print("Message ID? (Press ENTER for 1)")
        let messageID = readLine(strippingNewline: true)
        let id = (messageID ?? "").isEmpty ? "1" : messageID!
        deeplink.path = deeplink.path.replacingOccurrences(of: "{MESSAGE_ID}", with: id)
    }

    // ASK for Order ID
    if deeplink.path.contains("{ORDER_ID}") {
        print("Order ID? (Press ENTER for 406766536)")
        let orderID = readLine(strippingNewline: true)
        let id = (orderID ?? "").isEmpty ? "406766536" : orderID!
        deeplink.path = deeplink.path.replacingOccurrences(of: "{ORDER_ID}", with: id)
    }

    let urlString = generateURL(action: action, deeplink: deeplink)

    if action.title.starts(with: "Firebase"),
       let urlString = urlString {
        let firebaseUrlString = generateFirebaseDynamicLinkURL(urlString: urlString)
        sendLink(firebaseUrlString)
    } else {
        sendLink(urlString)
    }
}

while true {
    makeDeeplink()
}

