//
//  Page.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2022 Susan Cheng. All rights reserved.
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

extension WKHtml2Pdf {
    
    public struct Page {
        
        public var html: Data
        
        public var enableBackground: Bool = true
        
        public var enableJavaScript: Bool = true
        
        public var enableExternalLinks: Bool = true
        
        public var enableInternalLinks: Bool = true
        
        public var enableForms: Bool = false
        
        public var javascriptDelay: Int?
        
        public var keepRelativeLinks: Bool = false
        
        public var loadErrorHandling: Handler?
        
        public var loadMediaErrorHandling: Handler?
        
        public var enableLocalFileAccess: Bool = false
        
        public var minimumFontSize: Int?
        
        public var pageOffset: Int?
        
        public var zoom: Double?
        
        public init(html: String) {
            self.html = html.data(using: .utf8) ?? Data()
        }
        
        public init(html: Data) {
            self.html = html
        }
    }
}

extension WKHtml2Pdf.Page {
    
    public enum Handler: String {
        
        case abort, ignore, skip
    }
}
