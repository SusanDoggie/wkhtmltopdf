//
//  wkhtmltopdf.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2020 Susan Cheng. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

public struct WKHtml2Pdf {
    
    #if os(macOS)
    
    private static let binary_path = "/usr/local/bin/wkhtmltopdf"
    
    #elseif os(Linux)
    
    private static let binary_path = "/usr/bin/wkhtmltopdf"
    
    public var useXvfb: Bool = false
    
    #endif
    
    public var paperSize: PaperSize?
    
    public var grayScale: Bool = false
    
    public var lowQuality: Bool = false
    
    public var orientation: Orientation?
    
    public var topMargin: Double?
    public var rightMargin: Double?
    public var bottomMargin: Double?
    public var leftMargin: Double?
    
    public var pageWidth: Double?
    public var pageHeight: Double?
    
    public init() { }
    
}

extension WKHtml2Pdf {
    
    public enum Orientation: String {
        
        case Portrait
        case Landscape
    }
    
    public enum PaperSize: String {
        case A0, A1, A2, A3, A4, A5, A6, A7, A8, A9
        case B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10
        case C5E
        case Comm10E
        case DLE
        case Executive
        case Folio
        case Ledger
        case Legal
        case Letter
        case Tabloid
    }
}

extension WKHtml2Pdf {
    
    public func generate(pages: [Page]) throws -> Data {
        
        let pages = try pages.map { try $0.fileHandler() }
        
        return try withExtendedLifetime(pages) {
            
            let process = Process()
            let stdout = Pipe()
            
            var arguments = self.arguments
            arguments.append(contentsOf: pages.flatMap { $0.encode() })
            arguments.append("-")
            
            #if os(Linux)
            
            if useXvfb {
                process.executableURL = URL(fileURLWithPath: "/usr/bin/xvfb-run")
                arguments.insert(WKHtml2Pdf.binary_path, at: 0)
            } else {
                process.executableURL = URL(fileURLWithPath: WKHtml2Pdf.binary_path)
            }
            
            #else

            if #available(macOS 10.13, *) {
                process.executableURL = URL(fileURLWithPath: WKHtml2Pdf.binary_path)
            } else {
                process.launchPath = WKHtml2Pdf.binary_path
            }
            
            #endif

            process.arguments = arguments
            process.standardOutput = stdout
            
            if #available(macOS 10.13, *) {
                try process.run()
            } else {
                process.launch()
            }
            
            return stdout.fileHandleForReading.readDataToEndOfFile()
        }
    }
    
    private var arguments: [String] {
        
        var arguments: [String] = ["--quiet"]
        
        if let paperSize = paperSize {
            arguments.append("-s")
            arguments.append(paperSize.rawValue)
        }
        
        if grayScale {
            arguments.append("-g")
        }
        if lowQuality {
            arguments.append("-l")
        }
        
        if let orientation = orientation {
            arguments.append("-O")
            arguments.append(orientation.rawValue)
        }
        
        if let topMargin = topMargin {
            arguments.append("-T")
            arguments.append("\(topMargin)mm")
        }
        if let rightMargin = rightMargin {
            arguments.append("-R")
            arguments.append("\(rightMargin)mm")
        }
        if let bottomMargin = bottomMargin {
            arguments.append("-B")
            arguments.append("\(bottomMargin)mm")
        }
        if let leftMargin = leftMargin {
            arguments.append("-L")
            arguments.append("\(leftMargin)mm")
        }
        
        if let pageWidth = pageWidth {
            arguments.append("--page-width")
            arguments.append("\(pageWidth)mm")
        }
        if let pageHeight = pageHeight {
            arguments.append("--page-height")
            arguments.append("\(pageHeight)mm")
        }
        
        return arguments
    }
}

extension WKHtml2Pdf.Page {
    
    fileprivate var arguments: [String] {
        
        var arguments: [String] = []
        
        if !enableBackground {
            arguments.append("--no-background")
        }
        
        if !enableJavaScript {
            arguments.append("--disable-javascript")
        }
        
        if !enableExternalLinks {
            arguments.append("--disable-external-links")
        }
        
        if !enableInternalLinks {
            arguments.append("--disable-internal-links")
        }
        
        if enableForms {
            arguments.append("--enable-forms")
        }
        
        if let javascriptDelay = javascriptDelay {
            arguments.append("--javascript-delay")
            arguments.append("\(javascriptDelay)")
        }
        
        if keepRelativeLinks {
            arguments.append("--keep-relative-links")
        }
        
        if let loadErrorHandling = loadErrorHandling {
            arguments.append("--load-error-handling")
            arguments.append(loadErrorHandling.rawValue)
        }
        
        if let loadMediaErrorHandling = loadMediaErrorHandling {
            arguments.append("--load-media-error-handling")
            arguments.append(loadMediaErrorHandling.rawValue)
        }
        
        if enableLocalFileAccess {
            arguments.append("--enable-local-file-access")
        }
        
        if let minimumFontSize = minimumFontSize {
            arguments.append("--minimum-font-size")
            arguments.append("\(minimumFontSize)")
        }
        
        if let pageOffset = pageOffset {
            arguments.append("--page-offset")
            arguments.append("\(pageOffset)")
        }
        
        if let zoom = zoom {
            arguments.append("--zoom")
            arguments.append("\(zoom)")
        }
        
        return arguments
    }
    
}

extension WKHtml2Pdf.Page {
    
    fileprivate class PageFileHandler {
        
        let file: URL
        
        let arguments: [String]
        
        init(file: URL, arguments: [String]) {
            self.file = file
            self.arguments = arguments
        }
        
        deinit {
            try? FileManager.default.removeItem(at: file)
        }
        
        func encode() -> [String] {
            return [file.path] + arguments
        }
    }
    
    fileprivate func fileHandler() throws -> PageFileHandler {
        
        let unique_name = ProcessInfo.processInfo.globallyUniqueString
        let file = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("com.SusanDoggie.wkhtmltopdf.\(unique_name).html")
        
        try self.html.write(to: file)
        
        return PageFileHandler(file: file, arguments: self.arguments)
    }
}
