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
    
    private static let binary_path = "/usr/local/bin/wkhtmltopdf"
    
    public var parameters: [Parameter] = []
    
    public func generate(pages: [Page]) throws -> Data {
        
        let process = Process()
        let stdout = Pipe()
        process.launchPath = WKHtml2Pdf.binary_path
        
        let pages = try pages.map { try $0.fileHandler() }  
        
        process.arguments = self.parameters.flatMap { $0.values }
        process.arguments?.append("-")
        process.standardOutput = stdout
        process.launch()
        
        return stdout.fileHandleForReading.readDataToEndOfFile()
    }
}

extension WKHtml2Pdf.Page {
    
    fileprivate class PageFileHandler {
        
        let file: URL
        
        let parameters: [Parameter]
        
        init(file: URL, parameters: [Parameter]) {
            self.file = file
            self.parameters = parameters
        }
    }
    
    fileprivate func fileHandler() throws -> PageFileHandler {
        
        let unique_name = ProcessInfo.processInfo.globallyUniqueString
        let file = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("com.SusanDoggie.wkhtmltopdf.\(unique_name)")
        
        try self.html.write(to: file, atomically: true, encoding: .utf8)
        
        return PageFileHandler(file: file, parameters: parameters)
    }
}
