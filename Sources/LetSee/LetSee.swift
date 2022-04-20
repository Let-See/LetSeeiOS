final public class LetSee {
    private var webServer: WebServer
    public init(_ baseUrl: String = "") {
        self.webServer = .init(apiBaseUrl: baseUrl)
    }
#if canImport(Moya)
    public var logger: LetSeeLogs {
        LetSeeLogs(webServer: webServer)
    }
#endif
}
